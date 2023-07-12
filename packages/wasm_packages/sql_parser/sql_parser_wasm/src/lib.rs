// Use a procedural macro to generate bindings for the world we specified in `sql-parser.wit`
wit_bindgen::generate!("sql-parser");

use sqlparser::ast::{self};

// Comment out the following lines to include other generated wit interfaces
// use exports::sql_parser_namespace::sql_parser::*;
// use sql_parser_namespace::sql_parser::interface_name;

// Define a custom type and implement the generated trait for it which represents
// implementing all the necessary exported interfaces for this component.
struct WitImplementation;

export_sql_parser!(WitImplementation);

impl SqlParser for WitImplementation {
    fn parse_sql(sql_string: String) -> Result<ParsedSql, String> {
        let dialect = sqlparser::dialect::GenericDialect {};

        let mut state = ParserState::new();
        let statements = sqlparser::parser::Parser::parse_sql(&dialect, &sql_string)
            .map_err(|e| format!("Error parsing SQL: {}", e))?;
        state.process(statements);
        Ok(state.parsed)
    }
}

struct ParserState {
    pub parsed: ParsedSql,
}

impl ParserState {
    pub fn new() -> Self {
        Self {
            parsed: ParsedSql {
                statements: vec![],
                sql_ast_refs: vec![],
                sql_query_refs: vec![],
                sql_insert_refs: vec![],
                sql_update_refs: vec![],
                sql_select_refs: vec![],
                set_expr_refs: vec![],
                expr_refs: vec![],
                data_type_refs: vec![],
                array_agg_refs: vec![],
                list_agg_refs: vec![],
                sql_function_refs: vec![],
                table_with_joins_refs: vec![],
                warnings: vec![],
            },
        }
    }

    pub fn process(&mut self, statements: Vec<ast::Statement>) {
        statements.into_iter().for_each(|s| {
            let a = self.statement(s);
            self.parsed.statements.push(a);
        });
    }

    fn statement(&mut self, statement: ast::Statement) -> SqlAst {
        let v = match statement {
            ast::Statement::Query(query) => SqlAst::SqlQuery(self.query(*query)),
            ast::Statement::Insert { .. } => SqlAst::SqlInsert(self.insert(statement)),
            ast::Statement::Update { .. } => SqlAst::SqlUpdate(self.update(statement)),
            ast::Statement::CreateTable { .. } => {
                SqlAst::SqlCreateTable(self.create_table(statement))
            }
            ast::Statement::CreateView { .. } => SqlAst::SqlCreateView(self.create_view(statement)),
            ast::Statement::Delete { .. } => SqlAst::SqlDelete(self.delete(statement)),
            ast::Statement::CreateIndex { .. } => {
                SqlAst::SqlCreateIndex(self.create_index(statement))
            }
            ast::Statement::AlterTable { name, operation } => SqlAst::AlterTable(AlterTable {
                name: self.object_name(name),
                operation: self.alter_table_operation(operation),
            }),
            ast::Statement::AlterIndex { name, operation } => SqlAst::AlterIndex(AlterIndex {
                name: self.object_name(name),
                operation: self.alter_index_operation(operation),
            }),
            ast::Statement::Assert { condition, message } => SqlAst::SqlAssert(SqlAssert {
                condition: self.expr(condition),
                message: message.map(|message| self.expr(message)),
            }),
            ast::Statement::CreateVirtualTable {
                name,
                if_not_exists,
                module_name,
                module_args,
            } => SqlAst::CreateVirtualTable(CreateVirtualTable {
                name: self.object_name(name),
                if_not_exists,
                module_name: self.ident(module_name),
                module_args: module_args.into_iter().map(|a| self.ident(a)).collect(),
            }),
            ast::Statement::Declare {
                name,
                binary,
                sensitive,
                scroll,
                hold,
                query,
            } => SqlAst::SqlDeclare(SqlDeclare {
                name: self.ident(name),
                binary,
                sensitive,
                scroll,
                hold,
                query: self.query(*query),
            }),
            ast::Statement::SetVariable {
                local,
                hivevar,
                variable,
                value,
            } => SqlAst::SetVariable(SetVariable {
                local,
                hivevar,
                variable: self.object_name(variable),
                value: self.exprs(value),
            }),
            ast::Statement::StartTransaction { modes } => {
                SqlAst::StartTransaction(StartTransaction {
                    modes: modes
                        .into_iter()
                        .map(|m| self.transaction_mode(m))
                        .collect(),
                })
            }
            ast::Statement::SetTransaction {
                modes,
                snapshot,
                session,
            } => SqlAst::SetTransaction(SetTransaction {
                modes: modes
                    .into_iter()
                    .map(|m| self.transaction_mode(m))
                    .collect(),
                session,
                snapshot: snapshot.map(|s| self.sql_value(s)),
            }),

            ast::Statement::Commit { chain } => SqlAst::Commit(Commit { chain }),
            ast::Statement::Savepoint { name } => SqlAst::Savepoint(Savepoint {
                name: self.ident(name),
            }),
            ast::Statement::Rollback { chain } => SqlAst::Rollback(Rollback { chain }),

            ast::Statement::CreateFunction {
                or_replace,
                name,
                args,
                temporary,
                return_type,
                params,
            } => SqlAst::CreateFunction(CreateFunction {
                or_replace,
                name: self.object_name(name),
                args: args.map(|args| {
                    args.into_iter()
                        .map(|a| self.operate_function_arg(a))
                        .collect()
                }),
                temporary,
                return_type: return_type.map(|t| self.data_type(t)),
                params: self.create_function_body(params),
            }),
            ast::Statement::CreateProcedure {
                name,
                body,
                params,
                or_alter,
            } => SqlAst::CreateProcedure(CreateProcedure {
                name: self.object_name(name),
                body: body.into_iter().map(|s| self.statement_ref(s)).collect(),
                params: params.map(|params| {
                    params
                        .into_iter()
                        .map(|p| self.procedure_param(p))
                        .collect()
                }),
                or_alter,
            }),

            ast::Statement::CreateMacro {
                definition,
                temporary,
                or_replace,
                name,
                args,
            } => SqlAst::CreateMacro(CreateMacro {
                definition: self.macro_definition(definition),
                temporary,
                or_replace,
                name: self.object_name(name),
                args: args.map(|args| args.into_iter().map(|a| self.macro_arg(a)).collect()),
            }),
            ast::Statement::Execute { name, parameters } => SqlAst::SqlExecute(SqlExecute {
                name: self.ident(name),
                parameters: parameters.into_iter().map(|p| self.expr(p)).collect(),
            }),
            ast::Statement::CreateType {
                name,
                representation,
            } => SqlAst::CreateType(CreateType {
                name: self.object_name(name),
                representation: match representation {
                    ast::UserDefinedTypeRepresentation::Composite { attributes } => {
                        UserDefinedTypeRepresentation::CompositeUserDefinedType(
                            CompositeUserDefinedType {
                                attributes: attributes
                                    .into_iter()
                                    .map(|v| UserDefinedTypeCompositeAttributeDef {
                                        name: self.ident(v.name),
                                        data_type: self.data_type(v.data_type),
                                        collation: v.collation.map(|c| self.object_name(c)),
                                    })
                                    .collect(),
                            },
                        )
                    }
                },
            }),
            ast::Statement::Analyze {
                table_name,
                partitions,
                for_columns,
                columns,
                cache_metadata,
                noscan,
                compute_statistics,
            } => SqlAst::SqlAnalyze(SqlAnalyze {
                table_name: self.object_name(table_name),
                partitions: partitions.map(|p| self.exprs(p)),
                for_columns,
                columns: self.idents(columns),
                cache_metadata,
                noscan,
                compute_statistics,
            }),
            ast::Statement::Drop {
                object_type,
                if_exists,
                names,
                cascade,
                restrict,
                purge,
            } => SqlAst::SqlDrop(SqlDrop {
                object_type: self.object_type(object_type),
                if_exists,
                names: names.into_iter().map(|n| self.object_name(n)).collect(),
                cascade,
                restrict,
                purge,
            }),
            ast::Statement::DropFunction {
                if_exists,
                func_desc,
                option,
            } => SqlAst::SqlDropFunction(SqlDropFunction {
                if_exists,
                func_desc: func_desc
                    .into_iter()
                    .map(|v| self.drop_function_desc(v))
                    .collect(),
                option: option.map(|o| self.referential_action(o)),
            }),
            ast::Statement::ShowFunctions { filter } => SqlAst::ShowFunctions(ShowFunctions {
                filter: filter.map(|f| self.show_statement_filter(f)),
            }),
            ast::Statement::ShowVariable { variable } => SqlAst::ShowVariable(ShowVariable {
                variable: self.idents(variable),
            }),
            ast::Statement::ShowVariables { filter } => SqlAst::ShowVariables(ShowVariables {
                filter: filter.map(|f| self.show_statement_filter(f)),
            }),
            ast::Statement::ShowCreate { obj_type, obj_name } => SqlAst::ShowCreate(ShowCreate {
                obj_type: self.show_create_object(obj_type),
                obj_name: self.object_name(obj_name),
            }),

            ast::Statement::ShowColumns {
                extended,
                full,
                table_name,
                filter,
            } => SqlAst::ShowColumns(ShowColumns {
                extended,
                full,
                table_name: self.object_name(table_name),
                filter: filter.map(|f| self.show_statement_filter(f)),
            }),
            ast::Statement::ShowTables {
                extended,
                full,
                db_name,
                filter,
            } => SqlAst::ShowTables(ShowTables {
                extended,
                full,
                db_name: db_name.map(|n| self.ident(n)),
                filter: filter.map(|f| self.show_statement_filter(f)),
            }),
            ast::Statement::ShowCollation { filter } => SqlAst::ShowCollation(ShowCollation {
                filter: filter.map(|f| self.show_statement_filter(f)),
            }),
            ast::Statement::Comment {
                object_type,
                object_name,
                comment,
                if_exists,
            } => SqlAst::SqlComment(SqlComment {
                object_type: self.comment_object(object_type),
                object_name: self.object_name(object_name),
                comment,
                if_exists,
            }),
            ast::Statement::Use { db_name } => SqlAst::SqlUse(SqlUse {
                db_name: self.ident(db_name),
            }),
            ast::Statement::ExplainTable {
                describe_alias,
                table_name,
            } => SqlAst::SqlExplainTable(SqlExplainTable {
                describe_alias,
                table_name: self.object_name(table_name),
            }),
            ast::Statement::Explain {
                describe_alias,
                analyze,
                verbose,
                statement,
                format,
            } => SqlAst::SqlExplain(SqlExplain {
                describe_alias,
                analyze,
                verbose,
                statement: self.statement_ref(*statement),
                format: format.map(|f| self.analyze_format(f)),
            }),
            ast::Statement::Merge {
                into,
                table,
                source,
                on,
                clauses,
            } => SqlAst::SqlMerge(SqlMerge {
                into,
                table: self.table_factor(table),
                source: self.table_factor(source),
                on: self.expr(*on),
                clauses: clauses.into_iter().map(|c| self.merge_clause(c)).collect(),
            }),

            _ => todo!(),
        };
        v
    }

    fn query(&mut self, query: ast::Query) -> SqlQuery {
        SqlQuery {
            with: if let Some(l) = query.with {
                Some(self.with(l))
            } else {
                None
            },
            body: self.set_expr(query.body),
            order_by: self.order_by(query.order_by),
            limit: if let Some(l) = query.limit {
                Some(self.expr(l))
            } else {
                None
            },
            offset: self.offset(query.offset),
            fetch: self.fetch(query.fetch),
            locks: query
                .locks
                .into_iter()
                .map(|a| self.lock_clause(a))
                .collect(),
        }
    }

    fn expr(&mut self, expr: ast::Expr) -> Expr {
        match expr {
            ast::Expr::Identifier(ident) => Expr::Ident(self.ident(ident)),
            ast::Expr::CompoundIdentifier(idents) => Expr::CompoundIdentifier(self.idents(idents)),
            ast::Expr::UnaryOp { op, expr } => Expr::UnaryOp(UnaryOp {
                op: self.unary_op(op),
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::IsFalse(expr) => Expr::BoolUnaryOp(BoolUnaryOp {
                op: BoolUnaryOperator::IsFalse,
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::IsNotFalse(expr) => Expr::BoolUnaryOp(BoolUnaryOp {
                op: BoolUnaryOperator::IsNotFalse,
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::IsTrue(expr) => Expr::BoolUnaryOp(BoolUnaryOp {
                op: BoolUnaryOperator::IsTrue,
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::IsNotTrue(expr) => Expr::BoolUnaryOp(BoolUnaryOp {
                op: BoolUnaryOperator::IsNotTrue,
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::IsNull(expr) => Expr::BoolUnaryOp(BoolUnaryOp {
                op: BoolUnaryOperator::IsNull,
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::IsNotNull(expr) => Expr::BoolUnaryOp(BoolUnaryOp {
                op: BoolUnaryOperator::IsNotNull,
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::IsUnknown(expr) => Expr::BoolUnaryOp(BoolUnaryOp {
                op: BoolUnaryOperator::IsUnknown,
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::IsNotUnknown(expr) => Expr::BoolUnaryOp(BoolUnaryOp {
                op: BoolUnaryOperator::IsNotUnknown,
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::BinaryOp { left, op, right } => Expr::BinaryOp(BinaryOp {
                op: self.binary_operator(op),
                left: self.expr_ref(*left),
                right: self.expr_ref(*right),
            }),
            ast::Expr::IsDistinctFrom(left, right) => Expr::IsDistinctFrom(IsDistinctFrom {
                left: self.expr_ref(*left),
                right: self.expr_ref(*right),
            }),
            ast::Expr::IsNotDistinctFrom(left, right) => {
                Expr::IsNotDistinctFrom(IsNotDistinctFrom {
                    left: self.expr_ref(*left),
                    right: self.expr_ref(*right),
                })
            }
            ast::Expr::AnyOp(a) => Expr::AnyOp(AnyOp {
                expr: self.expr_ref(*a),
            }),
            ast::Expr::AllOp(a) => Expr::AllOp(AllOp {
                expr: self.expr_ref(*a),
            }),
            ast::Expr::Nested(expr) => Expr::NestedExpr(NestedExpr {
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::Exists { subquery, negated } => Expr::Exists(Exists {
                subquery: self.query_ref(subquery),
                negated,
            }),
            ast::Expr::Value(value) => Expr::SqlValue(self.sql_value(value)),
            ast::Expr::Subquery(query) => Expr::Subquery(Subquery {
                query: self.query_ref(query),
            }),

            ast::Expr::Function(func) => Expr::SqlFunctionRef(self.function_ref(func)),
            ast::Expr::InList {
                expr,
                list,
                negated,
            } => Expr::InList(InList {
                expr: self.expr_ref(*expr),
                list: list.into_iter().map(|e| self.expr_ref(e)).collect(),
                negated,
            }),
            ast::Expr::InSubquery {
                expr,
                subquery,
                negated,
            } => Expr::InSubquery(InSubquery {
                expr: self.expr_ref(*expr),
                subquery: self.query_ref(subquery),
                negated,
            }),
            ast::Expr::Between {
                expr,
                negated,
                low,
                high,
            } => Expr::Between(Between {
                expr: self.expr_ref(*expr),
                negated,
                low: self.expr_ref(*low),
                high: self.expr_ref(*high),
            }),

            ast::Expr::JsonAccess {
                left,
                operator,
                right,
            } => Expr::JsonAccess(JsonAccess {
                left: self.expr_ref(*left),
                operator: self.json_operator(operator),
                right: self.expr_ref(*right),
            }),
            ast::Expr::CompositeAccess { expr, key } => Expr::CompositeAccess(CompositeAccess {
                expr: self.expr_ref(*expr),
                key: self.ident(key),
            }),
            ast::Expr::InUnnest {
                expr,
                array_expr,
                negated,
            } => Expr::InUnnest(InUnnest {
                expr: self.expr_ref(*expr),
                array_expr: self.expr_ref(*array_expr),
                negated,
            }),
            ast::Expr::Like {
                negated,
                expr,
                pattern,
                escape_char,
            } => Expr::Like(Like {
                negated,
                expr: self.expr_ref(*expr),
                pattern: self.expr_ref(*pattern),
                escape_char,
            }),
            ast::Expr::ILike {
                negated,
                expr,
                pattern,
                escape_char,
            } => Expr::ILike(ILike {
                negated,
                expr: self.expr_ref(*expr),
                pattern: self.expr_ref(*pattern),
                escape_char,
            }),
            ast::Expr::SimilarTo {
                negated,
                expr,
                pattern,
                escape_char,
            } => Expr::SimilarTo(SimilarTo {
                negated,
                expr: self.expr_ref(*expr),
                pattern: self.expr_ref(*pattern),
                escape_char,
            }),
            ast::Expr::Cast { expr, data_type } => Expr::Cast(Cast {
                expr: self.expr_ref(*expr),
                data_type: self.data_type(data_type),
            }),
            ast::Expr::TryCast { expr, data_type } => Expr::TryCast(TryCast {
                expr: self.expr_ref(*expr),
                data_type: self.data_type(data_type),
            }),
            ast::Expr::SafeCast { expr, data_type } => Expr::SafeCast(SafeCast {
                expr: self.expr_ref(*expr),
                data_type: self.data_type(data_type),
            }),

            ast::Expr::AtTimeZone {
                timestamp,
                time_zone,
            } => Expr::AtTimeZone(AtTimeZone {
                timestamp: self.expr_ref(*timestamp),
                time_zone,
            }),
            ast::Expr::Extract { field, expr } => Expr::Extract(Extract {
                field: self.date_time_field(field),
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::Ceil { expr, field } => Expr::Ceil(Ceil {
                field: self.date_time_field(field),
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::Floor { expr, field } => Expr::Floor(Floor {
                field: self.date_time_field(field),
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::Position { expr, r#in } => Expr::Position(Position {
                expr: self.expr_ref(*expr),
                in_: self.expr_ref(*r#in),
            }),
            ast::Expr::Substring {
                expr,
                substring_from,
                substring_for,
            } => Expr::Substring(Substring {
                expr: self.expr_ref(*expr),
                substring_from: substring_from.map(|e| self.expr_ref(*e)),
                substring_for: substring_for.map(|e| self.expr_ref(*e)),
            }),
            ast::Expr::Trim {
                expr,
                trim_where,
                trim_what,
            } => Expr::Trim(Trim {
                expr: self.expr_ref(*expr),
                trim_where: trim_where.map(|trim_where| self.trim_where_field(trim_where)),
                trim_what: trim_what.map(|trim_what| self.expr_ref(*trim_what)),
            }),
            ast::Expr::Overlay {
                expr,
                overlay_what,
                overlay_from,
                overlay_for,
            } => Expr::Overlay(Overlay {
                expr: self.expr_ref(*expr),
                overlay_what: self.expr_ref(*overlay_what),
                overlay_from: self.expr_ref(*overlay_from),
                overlay_for: overlay_for.map(|e| self.expr_ref(*e)),
            }),
            ast::Expr::Collate { collation, expr } => Expr::Collate(Collate {
                collation: self.object_name(collation),
                expr: self.expr_ref(*expr),
            }),
            ast::Expr::IntroducedString { introducer, value } => {
                Expr::IntroducedString(IntroducedString {
                    introducer,
                    value: self.sql_value(value),
                })
            }
            ast::Expr::TypedString { data_type, value } => Expr::TypedString(TypedString {
                data_type: self.data_type(data_type),
                value,
            }),
            ast::Expr::MapAccess { column, keys } => Expr::MapAccess(MapAccess {
                column: self.expr_ref(*column),
                keys: keys.into_iter().map(|e| self.expr_ref(e)).collect(),
            }),

            ast::Expr::Case {
                operand,
                conditions,
                results,
                else_result,
            } => Expr::CaseExpr(CaseExpr {
                operand: operand.map(|o| self.expr_ref(*o)),
                conditions: conditions.into_iter().map(|c| self.expr_ref(c)).collect(),
                results: results.into_iter().map(|r| self.expr_ref(r)).collect(),
                else_result: else_result.map(|e| self.expr_ref(*e)),
            }),
            ast::Expr::ListAgg(l) => Expr::ListAggRef(self.list_agg_ref(l)),
            ast::Expr::ArrayAgg(l) => Expr::ArrayAggRef(self.array_agg_ref(l)),
            ast::Expr::ArraySubquery(l) => Expr::ArraySubquery(ArraySubquery {
                query: self.query_ref(l),
            }),
            ast::Expr::GroupingSets(l) => Expr::GroupingSets(GroupingSets {
                values: l
                    .into_iter()
                    .map(|s| s.into_iter().map(|e| self.expr_ref(e)).collect())
                    .collect(),
            }),
            ast::Expr::Cube(l) => Expr::CubeExpr(CubeExpr {
                values: l
                    .into_iter()
                    .map(|s| s.into_iter().map(|e| self.expr_ref(e)).collect())
                    .collect(),
            }),
            ast::Expr::Rollup(l) => Expr::RollupExpr(RollupExpr {
                values: l
                    .into_iter()
                    .map(|s| s.into_iter().map(|e| self.expr_ref(e)).collect())
                    .collect(),
            }),
            ast::Expr::Tuple(l) => Expr::TupleExpr(TupleExpr {
                values: l.into_iter().map(|s| self.expr_ref(s)).collect(),
            }),
            ast::Expr::ArrayIndex { obj, indexes } => Expr::ArrayIndex(ArrayIndex {
                obj: self.expr_ref(*obj),
                indexes: indexes.into_iter().map(|i| self.expr_ref(i)).collect(),
            }),
            ast::Expr::MatchAgainst {
                columns,
                match_value,
                opt_search_modifier,
            } => Expr::MatchAgainst(MatchAgainst {
                columns: columns.into_iter().map(|c| self.ident(c)).collect(),
                match_value: self.sql_value(match_value),
                opt_search_modifier: opt_search_modifier.map(|s| self.search_modifier(s)),
            }),
            ast::Expr::Array(values) => Expr::ArrayExpr(ArrayExpr {
                elem: values.elem.into_iter().map(|e| self.expr_ref(e)).collect(),
                named: values.named,
            }),
            ast::Expr::Interval(l) => Expr::IntervalExpr(IntervalExpr {
                value: self.expr_ref(*l.value),
                leading_field: l.leading_field.map(|v| self.date_time_field(v)),
                leading_precision: l.leading_precision,
                last_field: l.last_field.map(|v| self.date_time_field(v)),
                fractional_seconds_precision: l.fractional_seconds_precision,
            }),
            ast::Expr::AggregateExpressionWithFilter { expr, filter } => {
                Expr::AggregateExpressionWithFilter(AggregateExpressionWithFilter {
                    expr: self.expr_ref(*expr),
                    filter: self.expr_ref(*filter),
                })
            }
        }
    }

    fn ident(&mut self, ident: ast::Ident) -> Ident {
        Ident {
            value: ident.value,
            quote_style: ident.quote_style,
        }
    }

    fn idents(&mut self, idents: Vec<ast::Ident>) -> Vec<Ident> {
        idents.into_iter().map(|i| self.ident(i)).collect()
    }

    fn order_by(&mut self, order_by: Vec<ast::OrderByExpr>) -> Vec<OrderByExpr> {
        order_by
            .into_iter()
            .map(|i| OrderByExpr {
                expr: self.expr(i.expr),
                asc: i.asc,
                nulls_first: i.nulls_first,
            })
            .collect()
    }

    fn set_expr(&mut self, body: Box<ast::SetExpr>) -> SetExpr {
        match *body {
            ast::SetExpr::Select(v) => SetExpr::SqlSelectRef(self.select_ref(v)),
            ast::SetExpr::Query(v) => SetExpr::SqlQueryRef(self.query_ref(v)),
            ast::SetExpr::SetOperation {
                op,
                left,
                right,
                set_quantifier,
            } => SetExpr::SetOperation(SetOperation {
                op: self.set_operator(op),
                left: self.set_expr_ref(left),
                right: self.set_expr_ref(right),
                set_quantifier: self.set_quantifier(set_quantifier),
            }),
            ast::SetExpr::Values(v) => SetExpr::Values(self.values(v)),
            ast::SetExpr::Insert(v) => SetExpr::SqlInsertRef(self.insert_ref(v)),
            ast::SetExpr::Update(v) => SetExpr::SqlUpdateRef(self.update_ref(v)),
            ast::SetExpr::Table(v) => SetExpr::Table(self.table(v)),
        }
    }

    fn query_ref(&mut self, v: Box<ast::Query>) -> SqlQueryRef {
        let q = self.query(*v);
        let index = self.parsed.sql_query_refs.len() as u32;
        self.parsed.sql_query_refs.push(q);
        SqlQueryRef { index }
    }

    fn with(&mut self, with: ast::With) -> With {
        With {
            recursive: with.recursive,
            cte_tables: with
                .cte_tables
                .into_iter()
                .map(|c| self.cte(c))
                .collect::<Vec<_>>(),
        }
    }

    fn select_ref(&mut self, v: Box<ast::Select>) -> SqlSelectRef {
        let s = self.select(*v);
        let index = self.parsed.sql_select_refs.len() as u32;
        self.parsed.sql_select_refs.push(s);
        SqlSelectRef { index }
    }

    fn values(&mut self, v: ast::Values) -> Values {
        Values {
            explicit_row: v.explicit_row,
            rows: v
                .rows
                .into_iter()
                .map(|r| r.into_iter().map(|e| self.expr(e)).collect())
                .collect(),
        }
    }

    fn insert(&mut self, v: ast::Statement) -> SqlInsert {
        match v {
            ast::Statement::Insert {
                or,
                into,
                table_name,
                columns,
                overwrite,
                source,
                partitioned,
                after_columns,
                table,
                on,
                returning,
            } => SqlInsert {
                or: or.map(|v| self.sqlite_on_conflict(v)),
                into,
                table_name: self.object_name(table_name),
                columns: self.idents(columns),
                overwrite,
                source: self.query(*source),
                partitioned: partitioned.map(|v| self.exprs(v)),
                after_columns: self.idents(after_columns),
                table,
                on: on.map(|v| self.on_insert(v)),
                returning: returning.map(|v| self.select_items(v)),
            },
            _ => unreachable!("insert statement {}", v),
        }
    }

    fn sqlite_on_conflict(&mut self, e: ast::SqliteOnConflict) -> SqliteOnConflict {
        match e {
            ast::SqliteOnConflict::Rollback => SqliteOnConflict::Rollback,
            ast::SqliteOnConflict::Abort => SqliteOnConflict::Abort,
            ast::SqliteOnConflict::Fail => SqliteOnConflict::Fail,
            ast::SqliteOnConflict::Ignore => SqliteOnConflict::Ignore,
            ast::SqliteOnConflict::Replace => SqliteOnConflict::Replace,
        }
    }

    fn insert_ref(&mut self, v: ast::Statement) -> SqlInsertRef {
        let i = self.insert(v);
        let index = self.parsed.sql_insert_refs.len() as u32;
        self.parsed.sql_insert_refs.push(i);
        SqlInsertRef { index }
    }

    fn update(&mut self, v: ast::Statement) -> SqlUpdate {
        match v {
            ast::Statement::Update {
                table,
                assignments,
                from,
                selection,
                returning,
            } => SqlUpdate {
                table: self.table_with_joins(table),
                assignments: self.assignments(assignments),
                from: from.map(|v| self.table_with_joins(v)),
                selection: selection.map(|v| self.expr(v)),
                returning: returning.map(|v| self.select_items(v)),
            },
            _ => unreachable!("update statement {}", v),
        }
    }

    fn update_ref(&mut self, v: ast::Statement) -> SqlUpdateRef {
        let u = self.update(v);
        let index = self.parsed.sql_update_refs.len() as u32;
        self.parsed.sql_update_refs.push(u);
        SqlUpdateRef { index }
    }

    fn delete(&mut self, v: ast::Statement) -> SqlDelete {
        match v {
            ast::Statement::Delete {
                tables,
                from,
                using,
                selection,
                returning,
            } => SqlDelete {
                tables: tables.into_iter().map(|v| self.object_name(v)).collect(),
                from: from.into_iter().map(|v| self.table_with_joins(v)).collect(),
                using: using.map(|using| {
                    using
                        .into_iter()
                        .map(|v| self.table_with_joins(v))
                        .collect()
                }),
                selection: selection.map(|v| self.expr(v)),
                returning: returning.map(|v| self.select_items(v)),
            },
            _ => unreachable!("delete statement {}", v),
        }
    }

    // fn delete_ref(&mut self, v: ast::Statement) -> SqlDeleteRef {
    //     let u = self.delete(v);
    //     let index = self.parsed.sql_delete_refs.len() as u32;
    //     self.parsed.sql_delete_refs.push(u);
    //     SqlDeleteRef { index }
    // }

    fn create_table(&mut self, v: ast::Statement) -> SqlCreateTable {
        match v {
            ast::Statement::CreateTable {
                or_replace,
                temporary,
                external,
                global,
                if_not_exists,
                transient,
                name,
                columns,
                constraints,
                hive_distribution,
                hive_formats,
                table_properties,
                with_options,
                file_format,
                location,
                query,
                without_rowid,
                like,
                clone,
                engine,
                default_charset,
                collation,
                on_commit,
                on_cluster,
                order_by,
                strict,
            } => SqlCreateTable {
                or_replace,
                temporary,
                external,
                global,
                if_not_exists,
                transient,
                name: self.object_name(name),
                columns: columns.into_iter().map(|c| self.column_def(c)).collect(),
                constraints: self.table_constraints(constraints),
                // hive_distribution,
                // hive_formats,
                table_properties: self.sql_options(table_properties),
                with_options: self.sql_options(with_options),
                file_format: self.file_format(file_format),
                location,
                query: query.map(|v| self.query(*v)),
                without_rowid,
                like: like.map(|v| self.object_name(v)),
                clone: clone.map(|v| self.object_name(v)),
                engine,
                default_charset,
                collation,
                on_commit: self.on_commit(on_commit),
                on_cluster,
                order_by: order_by.map(|v| self.idents(v)),
                strict,
            },
            _ => unreachable!("create_table statement {}", v),
        }
    }

    fn create_view(&mut self, v: ast::Statement) -> SqlCreateView {
        match v {
            ast::Statement::CreateView {
                or_replace,
                materialized,
                name,
                columns,
                query,
                with_options,
                cluster_by,
            } => SqlCreateView {
                or_replace,
                materialized,
                name: self.object_name(name),
                columns: columns.into_iter().map(|c| self.ident(c)).collect(),
                query: self.query(*query),
                with_options: self.sql_options(with_options),
                cluster_by: self.idents(cluster_by),
            },
            _ => unreachable!("create_view statement {}", v),
        }
    }

    fn create_index(&mut self, v: ast::Statement) -> SqlCreateIndex {
        match v {
            ast::Statement::CreateIndex {
                name,
                table_name,
                using,
                columns,
                unique,
                if_not_exists,
            } => SqlCreateIndex {
                name: self.object_name(name),
                table_name: self.object_name(table_name),
                using: using.map(|using| self.ident(using)),
                columns: self.order_by(columns),
                unique,
                if_not_exists,
            },
            _ => unreachable!("create_view statement {}", v),
        }
    }

    fn column_def(&mut self, v: ast::ColumnDef) -> ColumnDef {
        ColumnDef {
            name: self.ident(v.name),
            data_type: self.data_type(v.data_type),
            collation: v.collation.map(|c| self.object_name(c)),
            options: v
                .options
                .into_iter()
                .map(|o| self.column_option_def(o))
                .collect(),
        }
    }

    fn column_option_def(&mut self, v: ast::ColumnOptionDef) -> ColumnOptionDef {
        ColumnOptionDef {
            name: v.name.map(|v| self.ident(v)),
            option: self.column_option(v.option),
        }
    }

    fn column_option(&mut self, v: ast::ColumnOption) -> ColumnOption {
        match v {
            ast::ColumnOption::Null => ColumnOption::Null,
            ast::ColumnOption::NotNull => ColumnOption::NotNull,
            ast::ColumnOption::Default(e) => ColumnOption::Default(self.expr(e)),
            ast::ColumnOption::Unique { is_primary } => {
                ColumnOption::Unique(UniqueOption { is_primary })
            }
            ast::ColumnOption::ForeignKey {
                foreign_table,
                referred_columns,
                on_delete,
                on_update,
            } => ColumnOption::ForeignKey(ForeignKeyOption {
                foreign_table: self.object_name(foreign_table),
                referred_columns: self.idents(referred_columns),
                on_delete: on_delete.map(|v| self.referential_action(v)),
                on_update: on_update.map(|v| self.referential_action(v)),
            }),
            ast::ColumnOption::Check(e) => ColumnOption::Check(self.expr(e)),
            ast::ColumnOption::DialectSpecific(v) => ColumnOption::DialectSpecific(
                v.into_iter().map(|token| token.to_string()).collect(),
            ),
            ast::ColumnOption::CharacterSet(o) => ColumnOption::CharacterSet(self.object_name(o)),
            ast::ColumnOption::Comment(v) => ColumnOption::Comment(v),
            ast::ColumnOption::OnUpdate(e) => ColumnOption::OnUpdate(self.expr(e)),
            ast::ColumnOption::Generated {
                generated_as,
                sequence_options,
                generation_expr,
            } => ColumnOption::Generated(GeneratedOption {
                generated_as: self.generated_as(generated_as),
                sequence_options: sequence_options
                    .map(|v| v.into_iter().map(|v| self.sequence_options(v)).collect()),
                generation_expr: generation_expr.map(|v| self.expr(v)),
            }),
        }
    }

    fn sql_options(&mut self, v: Vec<ast::SqlOption>) -> Vec<SqlOption> {
        v.into_iter().map(|c| self.sql_option(c)).collect()
    }

    fn sql_option(&mut self, v: ast::SqlOption) -> SqlOption {
        SqlOption {
            name: self.ident(v.name),
            value: self.sql_value(v.value),
        }
    }

    fn table(&mut self, v: Box<ast::Table>) -> Table {
        Table {
            table_name: v.table_name,
            schema_name: v.schema_name,
        }
    }

    fn set_expr_ref(&mut self, left: Box<ast::SetExpr>) -> SetExprRef {
        let s = self.set_expr(left);
        let index = self.parsed.set_expr_refs.len() as u32;
        self.parsed.set_expr_refs.push(s);
        SetExprRef { index }
    }

    fn expr_ref(&mut self, expr: ast::Expr) -> ExprRef {
        let e = self.expr(expr);
        let index = self.parsed.expr_refs.len() as u32;
        self.parsed.expr_refs.push(e);
        ExprRef { index }
    }

    fn fetch(&mut self, fetch: Option<ast::Fetch>) -> Option<Fetch> {
        fetch.map(|f| Fetch {
            with_ties: f.with_ties,
            percent: f.percent,
            quantity: f.quantity.map(|e| self.expr(e)),
        })
    }

    fn set_operator(&mut self, op: ast::SetOperator) -> SetOperator {
        match op {
            ast::SetOperator::Union => SetOperator::Union,
            ast::SetOperator::Except => SetOperator::Except,
            ast::SetOperator::Intersect => SetOperator::Intersect,
        }
    }

    fn set_quantifier(&mut self, set_quantifier: ast::SetQuantifier) -> SetQuantifier {
        match set_quantifier {
            ast::SetQuantifier::Distinct => SetQuantifier::Distinct,
            ast::SetQuantifier::All => SetQuantifier::All,
            ast::SetQuantifier::None => SetQuantifier::None,
        }
    }

    fn offset(&mut self, offset: Option<ast::Offset>) -> Option<Offset> {
        offset.map(|o| Offset {
            value: self.expr(o.value),
            rows: match o.rows {
                ast::OffsetRows::None => OffsetRows::None,
                ast::OffsetRows::Row => OffsetRows::Row,
                ast::OffsetRows::Rows => OffsetRows::Rows,
            },
        })
    }

    fn lock_clause(&mut self, a: ast::LockClause) -> LockClause {
        LockClause {
            lock_type: self.lock_type(a.lock_type),
            of: a.of.map(|o| self.object_name(o)),
            nonblock: a.nonblock.map(|o| self.non_block(o)),
        }
    }

    fn unary_op(&mut self, op: ast::UnaryOperator) -> UnaryOperator {
        match op {
            ast::UnaryOperator::Plus => UnaryOperator::Plus,
            ast::UnaryOperator::Minus => UnaryOperator::Minus,
            ast::UnaryOperator::Not => UnaryOperator::Not,
            ast::UnaryOperator::PGBitwiseNot => UnaryOperator::PgBitwiseNot,
            ast::UnaryOperator::PGSquareRoot => UnaryOperator::PgSquareRoot,
            ast::UnaryOperator::PGCubeRoot => UnaryOperator::PgCubeRoot,
            ast::UnaryOperator::PGPostfixFactorial => UnaryOperator::PgPostfixFactorial,
            ast::UnaryOperator::PGPrefixFactorial => UnaryOperator::PgPrefixFactorial,
            ast::UnaryOperator::PGAbs => UnaryOperator::PgAbs,
        }
    }

    fn select(&mut self, v: ast::Select) -> SqlSelect {
        SqlSelect {
            distinct: v.distinct.map(|v| self.distinct(v)),
            top: v.top.map(|v| self.top(v)),
            projection: v
                .projection
                .into_iter()
                .map(|p| self.select_item(p))
                .collect(),
            into: v.into.map(|v| self.select_into(v)),
            from: v
                .from
                .into_iter()
                .map(|f| self.table_with_joins(f))
                .collect(),
            lateral_views: self.lateral_views(v.lateral_views),
            selection: v.selection.map(|e| self.expr(e)),
            group_by: self.exprs(v.group_by),
            cluster_by: self.exprs(v.cluster_by),
            distribute_by: self.exprs(v.distribute_by),
            sort_by: self.exprs(v.sort_by),
            having: v.having.map(|e| self.expr(e)),
            named_window: v
                .named_window
                .into_iter()
                .map(|w| self.named_window_definition(w))
                .collect(),
            qualify: v.qualify.map(|e| self.expr(e)),
        }
    }

    fn cte(&mut self, c: ast::Cte) -> CommonTableExpr {
        CommonTableExpr {
            alias: self.table_alias(c.alias),
            from: c.from.map(|f| self.ident(f)),
            query: self.query_ref(c.query),
        }
    }

    fn lock_type(&mut self, lock_type: ast::LockType) -> LockType {
        match lock_type {
            ast::LockType::Share => LockType::Share,
            ast::LockType::Update => LockType::Update,
        }
    }

    fn table_alias(&mut self, alias: ast::TableAlias) -> TableAlias {
        TableAlias {
            name: self.ident(alias.name),
            columns: alias.columns.into_iter().map(|c| self.ident(c)).collect(),
        }
    }

    fn select_item(&mut self, p: ast::SelectItem) -> SelectItem {
        match p {
            ast::SelectItem::UnnamedExpr(e) => SelectItem::UnnamedExpr(self.expr(e)),
            ast::SelectItem::ExprWithAlias { expr, alias } => {
                SelectItem::ExprWithAlias(ExprWithAlias {
                    expr: self.expr(expr),
                    alias: self.ident(alias),
                })
            }
            ast::SelectItem::QualifiedWildcard(o, w) => {
                SelectItem::QualifiedWildcard(QualifiedWildcard {
                    qualifier: self.object_name(o),
                    asterisk: self.wildcart_options(w),
                })
            }
            ast::SelectItem::Wildcard(w) => SelectItem::Wildcard(self.wildcart_options(w)),
        }
    }

    fn exprs(&mut self, e: Vec<ast::Expr>) -> Vec<Expr> {
        e.into_iter().map(|g| self.expr(g)).collect()
    }

    fn table_with_joins(&mut self, f: ast::TableWithJoins) -> TableWithJoins {
        TableWithJoins {
            relation: self.table_factor(f.relation),
            joins: f.joins.into_iter().map(|j| self.join(j)).collect(),
        }
    }

    fn table_with_joins_ref(&mut self, f: ast::TableWithJoins) -> TableWithJoinsRef {
        let t = self.table_with_joins(f);
        let index = self.parsed.table_with_joins_refs.len() as u32;
        self.parsed.table_with_joins_refs.push(t);
        TableWithJoinsRef { index }
    }

    fn object_name(&mut self, o: ast::ObjectName) -> ObjectName {
        o.0.into_iter().map(|i| self.ident(i)).collect()
    }

    fn non_block(&mut self, o: ast::NonBlock) -> NonBlock {
        match o {
            ast::NonBlock::Nowait => NonBlock::Nowait,
            ast::NonBlock::SkipLocked => NonBlock::SkipLocked,
        }
    }

    fn distinct(&mut self, v: ast::Distinct) -> Distinct {
        match v {
            ast::Distinct::On(on) => Distinct::On(self.exprs(on)),
            ast::Distinct::Distinct => Distinct::Distinct,
        }
    }

    fn top(&mut self, v: ast::Top) -> Top {
        Top {
            quantity: v.quantity.map(|v| self.expr(v)),
            with_ties: v.with_ties,
            percent: v.percent,
        }
    }

    fn select_into(&mut self, v: ast::SelectInto) -> SelectInto {
        SelectInto {
            temporary: v.temporary,
            unlogged: v.unlogged,
            table: v.table,
            name: self.object_name(v.name),
        }
    }

    fn named_window_definition(&mut self, w: ast::NamedWindowDefinition) -> NamedWindowDefinition {
        NamedWindowDefinition {
            name: self.ident(w.0),
            window_spec: self.window_spec(w.1),
        }
    }

    fn lateral_views(&mut self, lateral_views: Vec<ast::LateralView>) -> Vec<LateralView> {
        lateral_views
            .into_iter()
            .map(|l| self.lateral_view(l))
            .collect()
    }

    fn assignments(&mut self, assignments: Vec<ast::Assignment>) -> Vec<Assignment> {
        assignments
            .into_iter()
            .map(|a| self.assignment(a))
            .collect()
    }

    fn select_items(&mut self, v: Vec<ast::SelectItem>) -> Vec<SelectItem> {
        v.into_iter().map(|s| self.select_item(s)).collect()
    }

    fn on_insert(&mut self, v: ast::OnInsert) -> OnInsert {
        match v {
            ast::OnInsert::DuplicateKeyUpdate(ass) => {
                OnInsert::DuplicateKeyUpdate(self.assignments(ass))
            }
            ast::OnInsert::OnConflict(oc) => OnInsert::OnConflict(self.on_conflict(oc)),
            // TODO: non_exhaustive
            _ => todo!(), // ast::OnInsert::Expr(e) => OnInsert::Expr(self.expr(e)),
        }
    }

    fn lateral_view(&mut self, l: ast::LateralView) -> LateralView {
        LateralView {
            lateral_view: self.expr(l.lateral_view),
            lateral_view_name: self.object_name(l.lateral_view_name),
            lateral_col_alias: self.idents(l.lateral_col_alias),
            outer: l.outer,
        }
    }

    fn assignment(&mut self, a: ast::Assignment) -> Assignment {
        Assignment {
            id: self.idents(a.id),
            value: self.expr(a.value),
        }
    }

    fn window_spec(&mut self, w: ast::WindowSpec) -> WindowSpec {
        WindowSpec {
            partition_by: self.exprs(w.partition_by),
            order_by: self.order_by(w.order_by),
            window_frame: w.window_frame.map(|v| self.window_frame(v)),
        }
    }

    fn on_conflict(&mut self, oc: ast::OnConflict) -> OnConflict {
        OnConflict {
            conflict_target: oc.conflict_target.map(|v| self.conflict_target(v)),
            action: self.on_conflict_action(oc.action),
        }
    }

    fn join(&mut self, j: ast::Join) -> Join {
        Join {
            relation: self.table_factor(j.relation),
            join_operator: self.join_operator(j.join_operator),
        }
    }

    fn wildcart_options(&mut self, w: ast::WildcardAdditionalOptions) -> Asterisk {
        // TODO:
        Asterisk {}
    }

    fn table_factor(&mut self, relation: ast::TableFactor) -> TableFactor {
        match relation {
            ast::TableFactor::Table {
                name,
                alias,
                args,
                with_hints,
            } => TableFactor::TableFactorTable(TableFactorTable {
                name: self.object_name(name),
                alias: alias.map(|a| self.table_alias(a)),
                args: args.map(|a| self.function_args(a)),
                with_hints: self.exprs(with_hints),
            }),
            ast::TableFactor::Derived {
                lateral,
                subquery,
                alias,
            } => TableFactor::TableFactorDerived(TableFactorDerived {
                lateral,
                subquery: self.query_ref(subquery),
                alias: alias.map(|a| self.table_alias(a)),
            }),
            ast::TableFactor::NestedJoin {
                table_with_joins,
                alias,
            } => TableFactor::TableFactorNestedJoin(TableFactorNestedJoin {
                table_with_joins: self.table_with_joins_ref(*table_with_joins),
                alias: alias.map(|a| self.table_alias(a)),
            }),
            ast::TableFactor::UNNEST {
                alias,
                array_expr,
                with_offset,
                with_offset_alias,
            } => TableFactor::TableFactorUnnest(TableFactorUnnest {
                alias: alias.map(|a| self.table_alias(a)),
                array_expr: self.expr(*array_expr),
                with_offset,
                with_offset_alias: with_offset_alias.map(|a| self.ident(a)),
            }),
            ast::TableFactor::TableFunction { expr, alias } => {
                TableFactor::TableFactorTableFunction(TableFactorTableFunction {
                    expr: self.expr(expr),
                    alias: alias.map(|a| self.table_alias(a)),
                })
            }
            ast::TableFactor::Pivot {
                name,
                table_alias,
                aggregate_function,
                value_column,
                pivot_values,
                pivot_alias,
            } => TableFactor::TableFactorPivot(TableFactorPivot {
                name: self.object_name(name),
                table_alias: table_alias.map(|a| self.table_alias(a)),
                aggregate_function: self.expr(aggregate_function),
                value_column: self.idents(value_column),
                pivot_values: pivot_values
                    .into_iter()
                    .map(|v| self.sql_value(v))
                    .collect(),
                pivot_alias: pivot_alias.map(|a| self.table_alias(a)),
            }),
        }
    }

    fn join_operator(&mut self, v: ast::JoinOperator) -> JoinOperator {
        match v {
            ast::JoinOperator::Inner(j) => JoinOperator::Inner(self.join_constraint(j)),
            ast::JoinOperator::LeftOuter(j) => JoinOperator::LeftOuter(self.join_constraint(j)),
            ast::JoinOperator::RightOuter(j) => JoinOperator::RightOuter(self.join_constraint(j)),
            ast::JoinOperator::FullOuter(j) => JoinOperator::FullOuter(self.join_constraint(j)),
            ast::JoinOperator::CrossJoin => JoinOperator::CrossJoin,
            ast::JoinOperator::LeftSemi(j) => JoinOperator::LeftSemi(self.join_constraint(j)),
            ast::JoinOperator::RightSemi(j) => JoinOperator::RightSemi(self.join_constraint(j)),
            ast::JoinOperator::LeftAnti(j) => JoinOperator::LeftAnti(self.join_constraint(j)),
            ast::JoinOperator::RightAnti(j) => JoinOperator::RightAnti(self.join_constraint(j)),
            ast::JoinOperator::CrossApply => JoinOperator::CrossApply,
            ast::JoinOperator::OuterApply => JoinOperator::OuterApply,
        }
    }

    fn window_frame(&mut self, v: ast::WindowFrame) -> WindowFrame {
        WindowFrame {
            units: self.window_frame_units(v.units),
            start_bound: self.window_frame_bound(v.start_bound),
            end_bound: v.end_bound.map(|v| self.window_frame_bound(v)),
        }
    }

    fn window_frame_units(&mut self, v: ast::WindowFrameUnits) -> WindowFrameUnits {
        match v {
            ast::WindowFrameUnits::Rows => WindowFrameUnits::Rows,
            ast::WindowFrameUnits::Range => WindowFrameUnits::Range,
            ast::WindowFrameUnits::Groups => WindowFrameUnits::Groups,
        }
    }

    fn function_args(&mut self, a: Vec<ast::FunctionArg>) -> Vec<FunctionArg> {
        a.into_iter().map(|a| self.function_arg(a)).collect()
    }

    fn function_arg(&mut self, a: ast::FunctionArg) -> FunctionArg {
        match a {
            ast::FunctionArg::Named { name, arg } => FunctionArg::Named(FunctionArgExprNamed {
                name: self.ident(name),
                arg: self.function_arg_expr(arg),
            }),
            ast::FunctionArg::Unnamed(arg) => FunctionArg::Unnamed(self.function_arg_expr(arg)),
        }
    }

    fn join_constraint(&mut self, j: ast::JoinConstraint) -> JoinConstraint {
        match j {
            ast::JoinConstraint::On(e) => JoinConstraint::On(self.expr(e)),
            ast::JoinConstraint::Using(i) => JoinConstraint::Using(self.idents(i)),
            ast::JoinConstraint::Natural => JoinConstraint::Natural,
            ast::JoinConstraint::None => JoinConstraint::None,
        }
    }

    fn function_arg_expr(&mut self, arg: ast::FunctionArgExpr) -> FunctionArgExpr {
        match arg {
            ast::FunctionArgExpr::Expr(e) => FunctionArgExpr::Expr(self.expr(e)),
            ast::FunctionArgExpr::QualifiedWildcard(name) => {
                FunctionArgExpr::QualifiedWildcard(self.object_name(name))
            }
            ast::FunctionArgExpr::Wildcard => FunctionArgExpr::Wildcard,
        }
    }

    fn window_frame_bound(&mut self, v: ast::WindowFrameBound) -> WindowFrameBound {
        match v {
            ast::WindowFrameBound::CurrentRow => WindowFrameBound::CurrentRow,
            ast::WindowFrameBound::Preceding(e) => {
                WindowFrameBound::Preceding(e.map(|e| self.expr(*e)))
            }
            ast::WindowFrameBound::Following(e) => {
                WindowFrameBound::Following(e.map(|e| self.expr(*e)))
            }
        }
    }

    fn on_conflict_action(&mut self, action: ast::OnConflictAction) -> OnConflictAction {
        match action {
            ast::OnConflictAction::DoNothing => OnConflictAction::DoNothing,
            ast::OnConflictAction::DoUpdate(target) => OnConflictAction::DoUpdate(DoUpdate {
                selection: target.selection.map(|e| self.expr(e)),
                assignments: self.assignments(target.assignments),
            }),
        }
    }

    fn conflict_target(&mut self, v: ast::ConflictTarget) -> ConflictTarget {
        match v {
            ast::ConflictTarget::Columns(i) => ConflictTarget::Columns(self.idents(i)),
            ast::ConflictTarget::OnConstraint(name) => {
                ConflictTarget::OnConstraint(self.object_name(name))
            }
        }
    }

    fn binary_operator(&mut self, op: ast::BinaryOperator) -> BinaryOperator {
        match op {
            ast::BinaryOperator::Plus => BinaryOperator::Plus,
            ast::BinaryOperator::Minus => BinaryOperator::Minus,
            ast::BinaryOperator::Multiply => BinaryOperator::Multiply,
            ast::BinaryOperator::Divide => BinaryOperator::Divide,
            ast::BinaryOperator::Modulo => BinaryOperator::Modulo,
            ast::BinaryOperator::StringConcat => BinaryOperator::StringConcat,
            ast::BinaryOperator::Gt => BinaryOperator::Gt,
            ast::BinaryOperator::Lt => BinaryOperator::Lt,
            ast::BinaryOperator::GtEq => BinaryOperator::GtEq,
            ast::BinaryOperator::LtEq => BinaryOperator::LtEq,
            ast::BinaryOperator::Spaceship => BinaryOperator::Spaceship,
            ast::BinaryOperator::Eq => BinaryOperator::Eq,
            ast::BinaryOperator::NotEq => BinaryOperator::NotEq,
            ast::BinaryOperator::And => BinaryOperator::And,
            ast::BinaryOperator::Or => BinaryOperator::Or,
            ast::BinaryOperator::Xor => BinaryOperator::Xor,
            ast::BinaryOperator::BitwiseOr => BinaryOperator::BitwiseOr,
            ast::BinaryOperator::BitwiseAnd => BinaryOperator::BitwiseAnd,
            ast::BinaryOperator::BitwiseXor => BinaryOperator::BitwiseXor,
            ast::BinaryOperator::DuckIntegerDivide => BinaryOperator::DuckIntegerDivide,
            ast::BinaryOperator::MyIntegerDivide => BinaryOperator::MyIntegerDivide,
            ast::BinaryOperator::Custom(s) => BinaryOperator::Custom(s),
            ast::BinaryOperator::PGBitwiseXor => BinaryOperator::PgBitwiseXor,
            ast::BinaryOperator::PGBitwiseShiftLeft => BinaryOperator::PgBitwiseShiftLeft,
            ast::BinaryOperator::PGBitwiseShiftRight => BinaryOperator::PgBitwiseShiftRight,
            ast::BinaryOperator::PGExp => BinaryOperator::PgExp,
            ast::BinaryOperator::PGRegexMatch => BinaryOperator::PgRegexMatch,
            ast::BinaryOperator::PGRegexIMatch => BinaryOperator::PgRegexIMatch,
            ast::BinaryOperator::PGRegexNotMatch => BinaryOperator::PgRegexNotMatch,
            ast::BinaryOperator::PGRegexNotIMatch => BinaryOperator::PgRegexNotIMatch,
            ast::BinaryOperator::PGCustomBinaryOperator(c) => {
                BinaryOperator::PgCustomBinaryOperator(c)
            }
        }
    }

    fn sql_value(&mut self, value: ast::Value) -> SqlValue {
        match value {
            ast::Value::Number(value, long) => SqlValue::Number(NumberValue { value, long }),
            ast::Value::SingleQuotedString(s) => SqlValue::SingleQuotedString(s),
            ast::Value::DollarQuotedString(s) => {
                SqlValue::DollarQuotedString(self.dollar_quoted_string(s))
            }
            ast::Value::EscapedStringLiteral(s) => SqlValue::EscapedStringLiteral(s),
            ast::Value::SingleQuotedByteStringLiteral(s) => {
                SqlValue::SingleQuotedByteStringLiteral(s)
            }
            ast::Value::DoubleQuotedByteStringLiteral(s) => {
                SqlValue::DoubleQuotedByteStringLiteral(s)
            }
            ast::Value::RawStringLiteral(s) => SqlValue::RawStringLiteral(s),
            ast::Value::NationalStringLiteral(s) => SqlValue::NationalStringLiteral(s),
            ast::Value::HexStringLiteral(s) => SqlValue::HexStringLiteral(s),
            ast::Value::DoubleQuotedString(s) => SqlValue::DoubleQuotedString(s),
            ast::Value::Boolean(bool) => SqlValue::Boolean(bool),
            ast::Value::Null => SqlValue::Null,
            ast::Value::Placeholder(s) => SqlValue::Placeholder(s),
            ast::Value::UnQuotedString(s) => SqlValue::UnQuotedString(s),
        }
    }

    fn dollar_quoted_string(&mut self, value: ast::DollarQuotedString) -> DollarQuotedString {
        DollarQuotedString {
            tag: value.tag,
            value: value.value,
        }
    }

    fn table_constraints(
        &mut self,
        constraints: Vec<ast::TableConstraint>,
    ) -> Vec<TableConstraint> {
        constraints
            .into_iter()
            .map(|c| self.table_constraint(c))
            .collect()
    }

    fn table_constraint(&mut self, c: ast::TableConstraint) -> TableConstraint {
        match c {
            ast::TableConstraint::Unique {
                name,
                columns,
                is_primary,
            } => TableConstraint::UniqueConstraint(UniqueConstraint {
                is_primary,
                name: name.map(|n| self.ident(n)),
                columns: columns.into_iter().map(|c| self.ident(c)).collect(),
            }),
            ast::TableConstraint::ForeignKey {
                name,
                columns,
                foreign_table,
                referred_columns,
                on_delete,
                on_update,
            } => TableConstraint::ForeignKeyConstraint(ForeignKeyConstraint {
                name: name.map(|n| self.ident(n)),
                columns: columns.into_iter().map(|c| self.ident(c)).collect(),
                foreign_table: self.object_name(foreign_table),
                referred_columns: referred_columns
                    .into_iter()
                    .map(|c| self.ident(c))
                    .collect(),
                on_delete: on_delete.map(|v| self.referential_action(v)),
                on_update: on_update.map(|v| self.referential_action(v)),
            }),
            ast::TableConstraint::Check { name, expr } => {
                TableConstraint::CheckConstraint(CheckConstraint {
                    name: name.map(|n| self.ident(n)),
                    expr: self.expr(*expr),
                })
            }
            ast::TableConstraint::Index {
                display_as_key,
                name,
                index_type,
                columns,
            } => TableConstraint::IndexConstraint(IndexConstraint {
                display_as_key,
                name: name.map(|n| self.ident(n)),
                index_type: index_type.map(|index_type| self.index_type(index_type)),
                columns: columns.into_iter().map(|c| self.ident(c)).collect(),
            }),
            ast::TableConstraint::FulltextOrSpatial {
                fulltext,
                index_type_display,
                opt_index_name,
                columns,
            } => TableConstraint::FullTextOrSpatialConstraint(FullTextOrSpatialConstraint {
                fulltext,
                index_type_display: self.key_or_index_display(index_type_display),
                opt_index_name: opt_index_name.map(|n| self.ident(n)),
                columns: columns.into_iter().map(|c| self.ident(c)).collect(),
            }),
        }
    }

    fn referential_action(&mut self, v: ast::ReferentialAction) -> ReferentialAction {
        match v {
            ast::ReferentialAction::Restrict => ReferentialAction::Restrict,
            ast::ReferentialAction::Cascade => ReferentialAction::Cascade,
            ast::ReferentialAction::SetNull => ReferentialAction::SetNull,
            ast::ReferentialAction::NoAction => ReferentialAction::NoAction,
            ast::ReferentialAction::SetDefault => ReferentialAction::SetDefault,
        }
    }

    fn file_format(&mut self, file_format: Option<ast::FileFormat>) -> Option<FileFormat> {
        file_format.map(|f| match f {
            ast::FileFormat::TEXTFILE => FileFormat::Textfile,
            ast::FileFormat::SEQUENCEFILE => FileFormat::Sequencefile,
            ast::FileFormat::ORC => FileFormat::Orc,
            ast::FileFormat::PARQUET => FileFormat::Parquet,
            ast::FileFormat::AVRO => FileFormat::Avro,
            ast::FileFormat::RCFILE => FileFormat::Rcfile,
            ast::FileFormat::JSONFILE => FileFormat::Jsonfile,
        })
    }

    fn on_commit(&mut self, on_commit: Option<ast::OnCommit>) -> Option<OnCommit> {
        on_commit.map(|o| match o {
            ast::OnCommit::PreserveRows => OnCommit::PreserveRows,
            ast::OnCommit::DeleteRows => OnCommit::DeleteRows,
            ast::OnCommit::Drop => OnCommit::Drop,
        })
    }

    fn data_type(&mut self, data_type: ast::DataType) -> DataType {
        match data_type {
            ast::DataType::Character(length) => DataType::Character(self.character_length(length)),
            ast::DataType::Char(l) => DataType::Char(self.character_length(l)),
            ast::DataType::CharacterVarying(l) => {
                DataType::CharacterVarying(self.character_length(l))
            }
            ast::DataType::CharVarying(l) => DataType::CharVarying(self.character_length(l)),
            ast::DataType::Varchar(l) => DataType::Varchar(self.character_length(l)),
            ast::DataType::Nvarchar(l) => DataType::Nvarchar(l),
            ast::DataType::Uuid => DataType::Uuid,
            ast::DataType::CharacterLargeObject(length) => DataType::CharacterLargeObject(length),
            ast::DataType::CharLargeObject(l) => DataType::CharLargeObject(l),
            ast::DataType::Clob(l) => DataType::Clob(l),
            ast::DataType::Binary(l) => DataType::Binary(l),
            ast::DataType::Varbinary(l) => DataType::Varbinary(l),
            ast::DataType::Blob(l) => DataType::Blob(l),
            ast::DataType::Numeric(exact_number_info) => {
                DataType::Numeric(self.exact_number_info(exact_number_info))
            }
            ast::DataType::Decimal(exact_number_info) => {
                DataType::Decimal(self.exact_number_info(exact_number_info))
            }
            ast::DataType::BigNumeric(exact_number_info) => {
                DataType::BigNumeric(self.exact_number_info(exact_number_info))
            }
            ast::DataType::BigDecimal(exact_number_info) => {
                DataType::BigDecimal(self.exact_number_info(exact_number_info))
            }
            ast::DataType::Dec(exact_number_info) => {
                DataType::Dec(self.exact_number_info(exact_number_info))
            }
            ast::DataType::Float(l) => DataType::Float(l),
            ast::DataType::TinyInt(l) => DataType::TinyInt(l),
            ast::DataType::UnsignedTinyInt(l) => DataType::UnsignedTinyInt(l),
            ast::DataType::SmallInt(l) => DataType::SmallInt(l),
            ast::DataType::UnsignedSmallInt(l) => DataType::UnsignedSmallInt(l),
            ast::DataType::MediumInt(l) => DataType::MediumInt(l),
            ast::DataType::UnsignedMediumInt(l) => DataType::UnsignedMediumInt(l),
            ast::DataType::Int(l) => DataType::Int(l),
            ast::DataType::Integer(l) => DataType::Integer(l),
            ast::DataType::UnsignedInt(l) => DataType::UnsignedInt(l),
            ast::DataType::UnsignedInteger(l) => DataType::UnsignedInteger(l),
            ast::DataType::BigInt(l) => DataType::BigInt(l),
            ast::DataType::UnsignedBigInt(l) => DataType::UnsignedBigInt(l),
            ast::DataType::Real => DataType::Real,
            ast::DataType::Double => DataType::Double,
            ast::DataType::DoublePrecision => DataType::DoublePrecision,
            ast::DataType::Boolean => DataType::Boolean,
            ast::DataType::Date => DataType::Date,
            ast::DataType::Time(value, info) => DataType::Time(TimestampType {
                value,
                timezone_info: self.timezone_info(info),
            }),
            ast::DataType::Datetime(l) => DataType::Datetime(l),
            ast::DataType::Timestamp(value, info) => DataType::Timestamp(TimestampType {
                value,
                timezone_info: self.timezone_info(info),
            }),
            ast::DataType::Interval => DataType::Interval,
            ast::DataType::JSON => DataType::Json,
            ast::DataType::Regclass => DataType::Regclass,
            ast::DataType::Text => DataType::Text,
            ast::DataType::String => DataType::String,
            ast::DataType::Bytea => DataType::Bytea,
            ast::DataType::Custom(name, arguments) => DataType::Custom(CustomDataType {
                name: self.object_name(name),
                arguments,
            }),
            ast::DataType::Array(data_type_ref) => {
                DataType::Array(data_type_ref.map(|v| self.data_type_ref(*v)))
            }
            ast::DataType::Enum(values) => DataType::Enum(values),
            ast::DataType::Set(values) => DataType::Set(values),
        }
    }

    fn data_type_ref(&mut self, data_type: ast::DataType) -> DataTypeRef {
        let d = self.data_type(data_type);
        let index = self.parsed.data_type_refs.len() as u32;
        self.parsed.data_type_refs.push(d);
        DataTypeRef { index }
    }

    fn index_type(&mut self, e: ast::IndexType) -> IndexType {
        match e {
            ast::IndexType::BTree => IndexType::BTree,
            ast::IndexType::Hash => IndexType::Hash,
        }
    }

    fn key_or_index_display(
        &mut self,
        index_type_display: ast::KeyOrIndexDisplay,
    ) -> KeyOrIndexDisplay {
        match index_type_display {
            ast::KeyOrIndexDisplay::None => KeyOrIndexDisplay::None,
            ast::KeyOrIndexDisplay::Key => KeyOrIndexDisplay::Key,
            ast::KeyOrIndexDisplay::Index => KeyOrIndexDisplay::Index,
        }
    }

    fn character_length(
        &mut self,
        length: Option<ast::CharacterLength>,
    ) -> Option<CharacterLength> {
        length.map(|l| CharacterLength {
            length: l.length,
            unit: l.unit.map(|u| match u {
                ast::CharLengthUnits::Octets => CharLengthUnits::Octets,
                ast::CharLengthUnits::Characters => CharLengthUnits::Characters,
            }),
        })
    }

    fn exact_number_info(&mut self, exact_number_info: ast::ExactNumberInfo) -> ExactNumberInfo {
        match exact_number_info {
            ast::ExactNumberInfo::None => ExactNumberInfo {
                precision: None,
                scale: None,
            },
            ast::ExactNumberInfo::Precision(p) => ExactNumberInfo {
                precision: Some(p),
                scale: None,
            },
            ast::ExactNumberInfo::PrecisionAndScale(p, s) => ExactNumberInfo {
                precision: Some(p),
                scale: Some(s),
            },
        }
    }

    fn timezone_info(&mut self, info: ast::TimezoneInfo) -> TimezoneInfo {
        match info {
            ast::TimezoneInfo::None => TimezoneInfo::None,
            ast::TimezoneInfo::WithTimeZone => TimezoneInfo::WithTimezone,
            ast::TimezoneInfo::WithoutTimeZone => TimezoneInfo::WithoutTimezone,
            ast::TimezoneInfo::Tz => TimezoneInfo::Tz,
        }
    }

    fn sequence_options(&mut self, v: ast::SequenceOptions) -> SequenceOptions {
        match v {
            ast::SequenceOptions::IncrementBy(v, by) => SequenceOptions::IncrementBy(IncrementBy {
                increment: self.expr(v),
                by,
            }),
            ast::SequenceOptions::MinValue(v) => SequenceOptions::MinValue(self.min_max_value(v)),
            ast::SequenceOptions::MaxValue(v) => SequenceOptions::MaxValue(self.min_max_value(v)),
            ast::SequenceOptions::StartWith(v, with) => SequenceOptions::StartWith(StartWith {
                start: self.expr(v),
                with,
            }),
            ast::SequenceOptions::Cache(v) => SequenceOptions::Cache(self.expr(v)),
            ast::SequenceOptions::Cycle(v) => SequenceOptions::Cycle(v),
        }
    }

    fn min_max_value(&mut self, v: ast::MinMaxValue) -> MinMaxValue {
        match v {
            ast::MinMaxValue::Empty => MinMaxValue::Empty,
            ast::MinMaxValue::Some(v) => MinMaxValue::Some(self.expr(v)),
            ast::MinMaxValue::None => MinMaxValue::None,
        }
    }

    fn generated_as(&mut self, generated_as: ast::GeneratedAs) -> GeneratedAs {
        match generated_as {
            ast::GeneratedAs::Always => GeneratedAs::Always,
            ast::GeneratedAs::ByDefault => GeneratedAs::ByDefault,
            ast::GeneratedAs::ExpStored => GeneratedAs::ExpStored,
        }
    }

    fn alter_table_operation(
        &mut self,
        operation: ast::AlterTableOperation,
    ) -> AlterTableOperation {
        match operation {
            ast::AlterTableOperation::AddConstraint(v) => {
                AlterTableOperation::AddConstraint(AddConstraint {
                    constraint: self.table_constraint(v),
                })
            }
            ast::AlterTableOperation::AddColumn {
                column_keyword,
                if_not_exists,
                column_def,
            } => AlterTableOperation::AddColumn(AddColumn {
                column_keyword,
                if_not_exists,
                column_def: self.column_def(column_def),
            }),
            ast::AlterTableOperation::DropConstraint {
                if_exists,
                name,
                cascade,
            } => AlterTableOperation::DropConstraint(DropConstraint {
                if_exists,
                name: self.ident(name),
                cascade,
            }),
            ast::AlterTableOperation::DropColumn {
                column_name,
                if_exists,
                cascade,
            } => AlterTableOperation::DropColumn(DropColumn {
                column_name: self.ident(column_name),
                if_exists,
                cascade,
            }),
            ast::AlterTableOperation::DropPrimaryKey => {
                AlterTableOperation::DropPrimaryKey(DropPrimaryKey {})
            }
            ast::AlterTableOperation::RenamePartitions {
                old_partitions,
                new_partitions,
            } => AlterTableOperation::RenamePartitions(RenamePartitions {
                old_partitions: self.exprs(old_partitions),
                new_partitions: self.exprs(new_partitions),
            }),
            ast::AlterTableOperation::AddPartitions {
                if_not_exists,
                new_partitions,
            } => AlterTableOperation::AddPartitions(AddPartitions {
                if_not_exists,
                new_partitions: self.exprs(new_partitions),
            }),
            ast::AlterTableOperation::DropPartitions {
                partitions,
                if_exists,
            } => AlterTableOperation::DropPartitions(DropPartitions {
                partitions: self.exprs(partitions),
                if_exists,
            }),
            ast::AlterTableOperation::RenameColumn {
                old_column_name,
                new_column_name,
            } => AlterTableOperation::RenameColumn(RenameColumn {
                old_column_name: self.ident(old_column_name),
                new_column_name: self.ident(new_column_name),
            }),
            ast::AlterTableOperation::RenameTable { table_name } => {
                AlterTableOperation::RenameTable(RenameTable {
                    table_name: self.object_name(table_name),
                })
            }
            ast::AlterTableOperation::ChangeColumn {
                old_name,
                new_name,
                data_type,
                options,
            } => AlterTableOperation::ChangeColumn(ChangeColumn {
                old_name: self.ident(old_name),
                new_name: self.ident(new_name),
                data_type: self.data_type(data_type),
                options: options.into_iter().map(|v| self.column_option(v)).collect(),
            }),
            ast::AlterTableOperation::RenameConstraint { old_name, new_name } => {
                AlterTableOperation::RenameConstraint(RenameConstraint {
                    old_name: self.ident(old_name),
                    new_name: self.ident(new_name),
                })
            }
            ast::AlterTableOperation::AlterColumn { column_name, op } => {
                AlterTableOperation::AlterColumn(AlterColumn {
                    column_name: self.ident(column_name),
                    op: self.alter_column_operation(op),
                })
            }
            ast::AlterTableOperation::SwapWith { table_name } => {
                AlterTableOperation::SwapWith(SwapWith {
                    table_name: self.object_name(table_name),
                })
            }
        }
    }

    fn alter_index_operation(
        &mut self,
        operation: ast::AlterIndexOperation,
    ) -> AlterIndexOperation {
        match operation {
            ast::AlterIndexOperation::RenameIndex { index_name } => {
                AlterIndexOperation::RenameIndex(RenameIndex {
                    index_name: self.object_name(index_name),
                })
            }
        }
    }

    fn alter_column_operation(&mut self, op: ast::AlterColumnOperation) -> AlterColumnOperation {
        match op {
            ast::AlterColumnOperation::SetNotNull => AlterColumnOperation::SetNotNull,
            ast::AlterColumnOperation::DropNotNull => AlterColumnOperation::DropNotNull,
            ast::AlterColumnOperation::DropDefault => AlterColumnOperation::DropDefault,
            ast::AlterColumnOperation::SetDataType { data_type, using } => {
                AlterColumnOperation::SetDataType(SetDataType {
                    data_type: self.data_type(data_type),
                    using: using.map(|v| self.expr(v)),
                })
            }
            ast::AlterColumnOperation::SetDefault { value } => {
                AlterColumnOperation::SetDefault(SetDefault {
                    value: self.expr(value),
                })
            }
        }
    }

    fn macro_definition(&mut self, definition: ast::MacroDefinition) -> MacroDefinition {
        match definition {
            ast::MacroDefinition::Expr(e) => MacroDefinition::Expr(self.expr(e)),
            ast::MacroDefinition::Table(e) => MacroDefinition::Table(self.query(e)),
        }
    }

    fn transaction_mode(&mut self, m: ast::TransactionMode) -> TransactionMode {
        match m {
            ast::TransactionMode::AccessMode(m) => TransactionMode::AccessMode(match m {
                ast::TransactionAccessMode::ReadOnly => TransactionAccessMode::ReadOnly,
                ast::TransactionAccessMode::ReadWrite => TransactionAccessMode::ReadWrite,
            }),
            ast::TransactionMode::IsolationLevel(m) => TransactionMode::IsolationLevel(match m {
                ast::TransactionIsolationLevel::ReadUncommitted => {
                    TransactionIsolationLevel::ReadUncommitted
                }
                ast::TransactionIsolationLevel::ReadCommitted => {
                    TransactionIsolationLevel::ReadCommitted
                }
                ast::TransactionIsolationLevel::RepeatableRead => {
                    TransactionIsolationLevel::RepeatableRead
                }
                ast::TransactionIsolationLevel::Serializable => {
                    TransactionIsolationLevel::Serializable
                }
            }),
        }
    }

    fn statement_ref(&mut self, ast_statement: ast::Statement) -> SqlAstRef {
        let s = self.statement(ast_statement);
        let index = self.parsed.sql_ast_refs.len() as u32;
        self.parsed.sql_ast_refs.push(s);
        SqlAstRef { index }
    }

    fn create_function_body(&mut self, params: ast::CreateFunctionBody) -> CreateFunctionBody {
        CreateFunctionBody {
            language: params.language.map(|i| self.ident(i)),
            behavior: params.behavior.map(|v| match v {
                ast::FunctionBehavior::Immutable => FunctionBehavior::Immutable,
                ast::FunctionBehavior::Stable => FunctionBehavior::Stable,
                ast::FunctionBehavior::Volatile => FunctionBehavior::Volatile,
            }),
            as_: params.as_.map(|v| match v {
                ast::FunctionDefinition::SingleQuotedDef(s) => {
                    FunctionDefinition::SingleQuotedDef(s)
                }
                ast::FunctionDefinition::DoubleDollarDef(s) => {
                    FunctionDefinition::DoubleDollarDef(s)
                }
            }),
            return_: params.return_.map(|v| self.expr(v)),
            using: params.using.map(|v| self.create_function_using(v)),
        }
    }

    fn create_function_using(&mut self, p: ast::CreateFunctionUsing) -> CreateFunctionUsing {
        match p {
            ast::CreateFunctionUsing::Jar(s) => CreateFunctionUsing::Jar(s),
            ast::CreateFunctionUsing::File(s) => CreateFunctionUsing::File(s),
            ast::CreateFunctionUsing::Archive(s) => CreateFunctionUsing::Archive(s),
        }
    }

    fn macro_arg(&mut self, a: ast::MacroArg) -> MacroArg {
        MacroArg {
            name: self.ident(a.name),
            default_expr: a.default_expr.map(|d| self.expr(d)),
        }
    }

    fn procedure_param(&mut self, p: ast::ProcedureParam) -> ProcedureParam {
        ProcedureParam {
            name: self.ident(p.name),
            data_type: self.data_type(p.data_type),
        }
    }

    fn operate_function_arg(&mut self, p: ast::OperateFunctionArg) -> OperateFunctionArg {
        OperateFunctionArg {
            name: p.name.map(|n| self.ident(n)),
            data_type: self.data_type(p.data_type),
            default_expr: p.default_expr.map(|n| self.expr(n)),
            mode: p.mode.map(|n| self.arg_mode(n)),
        }
    }

    fn arg_mode(&mut self, p: ast::ArgMode) -> ArgMode {
        match p {
            ast::ArgMode::In => ArgMode::In,
            ast::ArgMode::Out => ArgMode::Out,
            ast::ArgMode::InOut => ArgMode::InOut,
        }
    }

    fn date_time_field(&mut self, field: ast::DateTimeField) -> DateTimeField {
        match field {
            ast::DateTimeField::Year => DateTimeField::Year,
            ast::DateTimeField::Month => DateTimeField::Month,
            ast::DateTimeField::Week => DateTimeField::Week,
            ast::DateTimeField::Day => DateTimeField::Day,
            ast::DateTimeField::Date => DateTimeField::Date,
            ast::DateTimeField::Hour => DateTimeField::Hour,
            ast::DateTimeField::Minute => DateTimeField::Minute,
            ast::DateTimeField::Second => DateTimeField::Second,
            ast::DateTimeField::Century => DateTimeField::Century,
            ast::DateTimeField::Decade => DateTimeField::Decade,
            ast::DateTimeField::Dow => DateTimeField::Dow,
            ast::DateTimeField::Doy => DateTimeField::Doy,
            ast::DateTimeField::Epoch => DateTimeField::Epoch,
            ast::DateTimeField::Isodow => DateTimeField::Isodow,
            ast::DateTimeField::Isoyear => DateTimeField::Isoyear,
            ast::DateTimeField::Julian => DateTimeField::Julian,
            ast::DateTimeField::Microsecond => DateTimeField::Microsecond,
            ast::DateTimeField::Microseconds => DateTimeField::Microseconds,
            ast::DateTimeField::Millenium => DateTimeField::Millenium,
            ast::DateTimeField::Millennium => DateTimeField::Millennium,
            ast::DateTimeField::Millisecond => DateTimeField::Millisecond,
            ast::DateTimeField::Milliseconds => DateTimeField::Milliseconds,
            ast::DateTimeField::Nanosecond => DateTimeField::Nanosecond,
            ast::DateTimeField::Nanoseconds => DateTimeField::Nanoseconds,
            ast::DateTimeField::Quarter => DateTimeField::Quarter,
            ast::DateTimeField::Timezone => DateTimeField::Timezone,
            ast::DateTimeField::TimezoneHour => DateTimeField::TimezoneHour,
            ast::DateTimeField::TimezoneMinute => DateTimeField::TimezoneMinute,
            ast::DateTimeField::NoDateTime => DateTimeField::NoDateTime,
        }
    }

    fn search_modifier(&mut self, s: ast::SearchModifier) -> SearchModifier {
        match s {
            ast::SearchModifier::InNaturalLanguageMode => SearchModifier::InNaturalLanguageMode,
            ast::SearchModifier::InNaturalLanguageModeWithQueryExpansion => {
                SearchModifier::InNaturalLanguageModeWithQueryExpansion
            }
            ast::SearchModifier::InBooleanMode => SearchModifier::InBooleanMode,
            ast::SearchModifier::WithQueryExpansion => SearchModifier::WithQueryExpansion,
        }
    }

    fn list_agg_ref(&mut self, l: ast::ListAgg) -> ListAggRef {
        let listagg = ListAgg {
            distinct: l.distinct,
            expr: self.expr(*l.expr),
            separator: l.separator.map(|s| self.expr(*s)),
            on_overflow: l.on_overflow.map(|s| self.list_agg_on_overflow(s)),
            within_group: self.order_by(l.within_group),
        };
        let index = self.parsed.list_agg_refs.len() as u32;
        self.parsed.list_agg_refs.push(listagg);
        ListAggRef { index }
    }

    fn array_agg_ref(&mut self, l: ast::ArrayAgg) -> ArrayAggRef {
        let arrayagg = ArrayAgg {
            distinct: l.distinct,
            expr: self.expr(*l.expr),
            order_by: l.order_by.map(|o| self.order_by(o)),
            limit: l.limit.map(|l| self.expr(*l)),
            within_group: l.within_group,
        };
        let index = self.parsed.array_agg_refs.len() as u32;
        self.parsed.array_agg_refs.push(arrayagg);
        ArrayAggRef { index }
    }

    fn json_operator(&mut self, operator: ast::JsonOperator) -> JsonOperator {
        match operator {
            ast::JsonOperator::Arrow => JsonOperator::Arrow,
            ast::JsonOperator::LongArrow => JsonOperator::LongArrow,
            ast::JsonOperator::HashArrow => JsonOperator::HashArrow,
            ast::JsonOperator::HashLongArrow => JsonOperator::HashLongArrow,
            ast::JsonOperator::Colon => JsonOperator::Colon,
            ast::JsonOperator::AtArrow => JsonOperator::AtArrow,
            ast::JsonOperator::ArrowAt => JsonOperator::ArrowAt,
            ast::JsonOperator::HashMinus => JsonOperator::HashMinus,
            ast::JsonOperator::AtQuestion => JsonOperator::AtQuestion,
            ast::JsonOperator::AtAt => JsonOperator::AtAt,
        }
    }

    fn function_ref(&mut self, func: ast::Function) -> SqlFunctionRef {
        let func = SqlFunction {
            name: self.object_name(func.name),
            args: func
                .args
                .into_iter()
                .map(|a| self.function_arg(a))
                .collect(),
            over: func.over.map(|o| self.window_type(o)),
            distinct: func.distinct,
            special: func.special,
            order_by: self.order_by(func.order_by),
        };
        let index = self.parsed.sql_function_refs.len() as u32;
        self.parsed.sql_function_refs.push(func);
        SqlFunctionRef { index }
    }

    fn trim_where_field(&mut self, trim_where: ast::TrimWhereField) -> TrimWhereField {
        match trim_where {
            ast::TrimWhereField::Both => TrimWhereField::Both,
            ast::TrimWhereField::Leading => TrimWhereField::Leading,
            ast::TrimWhereField::Trailing => TrimWhereField::Trailing,
        }
    }

    fn window_type(&mut self, o: ast::WindowType) -> WindowType {
        match o {
            ast::WindowType::WindowSpec(i) => WindowType::WindowSpec(self.window_spec(i)),
            ast::WindowType::NamedWindow(i) => WindowType::NamedWindow(self.ident(i)),
        }
    }

    fn list_agg_on_overflow(&mut self, s: ast::ListAggOnOverflow) -> ListAggOnOverflow {
        match s {
            ast::ListAggOnOverflow::Error => ListAggOnOverflow::Error,
            ast::ListAggOnOverflow::Truncate { filler, with_count } => {
                ListAggOnOverflow::Truncate(OnOverflowTruncate {
                    with_count,
                    filler: filler.map(|f| self.expr(*f)),
                })
            }
        }
    }

    fn merge_clause(&mut self, c: ast::MergeClause) -> MergeClause {
        match c {
            ast::MergeClause::MatchedUpdate {
                predicate,
                assignments,
            } => MergeClause::MatchedUpdate(MatchedUpdate {
                predicate: predicate.map(|p| self.expr(p)),
                assignments: assignments
                    .into_iter()
                    .map(|a| self.assignment(a))
                    .collect(),
            }),
            ast::MergeClause::MatchedDelete(predicate) => {
                MergeClause::MatchedDelete(MatchedDelete {
                    predicate: predicate.map(|p| self.expr(p)),
                })
            }
            ast::MergeClause::NotMatched {
                predicate,
                columns,
                values,
            } => MergeClause::NotMatched(NotMatched {
                predicate: predicate.map(|p| self.expr(p)),
                columns: columns.into_iter().map(|c| self.ident(c)).collect(),
                values: self.values(values),
            }),
        }
    }

    fn analyze_format(&mut self, f: ast::AnalyzeFormat) -> AnalyzeFormat {
        match f {
            ast::AnalyzeFormat::TEXT => AnalyzeFormat::Text,
            ast::AnalyzeFormat::GRAPHVIZ => AnalyzeFormat::Graphviz,
            ast::AnalyzeFormat::JSON => AnalyzeFormat::Json,
        }
    }

    fn comment_object(&mut self, object_type: ast::CommentObject) -> CommentObject {
        match object_type {
            ast::CommentObject::Column => CommentObject::Column,
            ast::CommentObject::Table => CommentObject::Table,
        }
    }

    fn show_statement_filter(&mut self, f: ast::ShowStatementFilter) -> ShowStatementFilter {
        match f {
            ast::ShowStatementFilter::Like(s) => ShowStatementFilter::Like(s),
            ast::ShowStatementFilter::ILike(s) => ShowStatementFilter::ILike(s),
            ast::ShowStatementFilter::Where(s) => ShowStatementFilter::Where(self.expr(s)),
        }
    }

    fn show_create_object(&mut self, obj_type: ast::ShowCreateObject) -> ShowCreateObject {
        match obj_type {
            ast::ShowCreateObject::Event => ShowCreateObject::Event,
            ast::ShowCreateObject::Function => ShowCreateObject::Function,
            ast::ShowCreateObject::Procedure => ShowCreateObject::Procedure,
            ast::ShowCreateObject::Table => ShowCreateObject::Table,
            ast::ShowCreateObject::Trigger => ShowCreateObject::Trigger,
            ast::ShowCreateObject::View => ShowCreateObject::View,
        }
    }

    fn drop_function_desc(&mut self, v: ast::DropFunctionDesc) -> DropFunctionDesc {
        DropFunctionDesc {
            name: self.object_name(v.name),
            args: v.args.map(|v| {
                v.into_iter()
                    .map(|v| self.operate_function_arg(v))
                    .collect()
            }),
        }
    }

    fn object_type(&mut self, object_type: ast::ObjectType) -> ObjectType {
        match object_type {
            ast::ObjectType::Table => ObjectType::Table,
            ast::ObjectType::View => ObjectType::View,
            ast::ObjectType::Index => ObjectType::Index,
            ast::ObjectType::Schema => ObjectType::Schema,
            ast::ObjectType::Role => ObjectType::Role,
            ast::ObjectType::Sequence => ObjectType::Sequence,
            ast::ObjectType::Stage => ObjectType::Stage,
        }
    }
}
