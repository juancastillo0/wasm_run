'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "9fd6ef9f20407e8b95a48e040ff54627",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "aa0c4b8ff0898aa1ac464edafc34a365",
"version.json": "6d04cb54e307c269ac10de742cfd1f67",
"index.html": "3c96d73b4ab789f4c85f963eec1d43e2",
"/": "3c96d73b4ab789f4c85f963eec1d43e2",
"main.dart.js": "ee77be5688655c79f2a02cb05e204d6a",
"sqlite3.wasm": "2068781fd3a05f89e76131a98da09b5b",
"assets/AssetManifest.json": "a4ba803ea937935cc83ac21a2230ba44",
"assets/packages/wasm_run/lib/assets/wasm-feature-detect.js": "fbba857d68dfbf499b84606326f6c942",
"assets/packages/wasm_run/lib/assets/browser_wasi_shim.js": "91ba950eb53119a764eecec75ed5bdb5",
"assets/packages/wasm_run/lib/assets/wasm.worker.js": "100dc1f86c19f6ddcc6ddf64d81388df",
"assets/packages/image_ops/lib/assets/image_ops_wasm.wasm": "a28394ae4ef4345a7300f94748073b6e",
"assets/packages/rust_crypto/lib/assets/rust_crypto_wasm.wasm": "14534e63438ba10c961e08b595b6fdf7",
"assets/packages/compression_rs/lib/assets/compression_rs_wasm.brotli.threads.wasm": "b299006721a7ff55f5fe740197f11390",
"assets/packages/compression_rs/lib/assets/compression_rs_wasm.threads.wasm": "6275a3402960142f22089e2637bbeb9f",
"assets/packages/compression_rs/lib/assets/compression_rs_wasm.wasm": "8b4d76dfb3af94ee9e2cfefae1fe4338",
"assets/packages/typesql_parser/lib/assets/typesql_parser_wasm.wasm": "f380ad7b53b940e64e0f2cc329b5f2de",
"assets/packages/typesql_parser/assets/typesql_parser_wasm.wasm": "f380ad7b53b940e64e0f2cc329b5f2de",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/wasm_parser/lib/assets/wasm_parser_wasm.wasm": "44713a36ff804554b9d0a9c110cdff3f",
"assets/packages/wasm_parser/lib/assets/wasm_parser_wasm.threads.wasm": "3be3bc21ee096503e103194a3e2146db",
"assets/packages/wasm_wit_component/lib/dart_wit_component.wasm": "a9a0d7d9e538cdd1bdea5a8c098f0264",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "12538f47884b51b8df32b54fd412d866",
"assets/fonts/MaterialIcons-Regular.otf": "0367ab89f6b19c37c3289d9e180afedd",
"assets/assets/images/resize-102x50.png": "bb6b0cdc54d6c2767663ae81b24d58cf",
"assets/assets/images/webp-convert.bmp": "fa31a8507ed15d8fc403be29c56d0752",
"assets/assets/images/resize-102x50-exact.png": "8f69839de3138459405b2129b8029e0b",
"assets/assets/images/webp-convert-blur2.bmp": "ea3246f73f967e2f3c375ead32b851da",
"assets/assets/images/crop-100x52.png": "552f1a0c26900da731e2c8ebde4471c2",
"assets/assets/images/code.png": "9e0cb968022c3d1082aa37b68e289def",
"assets/assets/images/resize-102x50.jpg": "9d7d9b59f7084e0f722631588cad27b7",
"assets/assets/images/gray-rot90.png": "e75f0fe35ffea8cb4fc55ad6d39c7060",
"assets/assets/images/webp-example.webp": "d7ada0276744162efb83ff627557df21",
"assets/assets/images/flip-h.png": "c8a426b34045f7ba06af6514b3a6b71a",
"assets/assets/images/convert.gif": "f4d7e51e364afd466232ba3bfc515e52",
"assets/assets/images/grayscale.png": "1fe2188f3f642d89a42ec217356c11de",
"assets/assets/images/contrast20.png": "b3e27f84ccee2d8751af01f4cd9b4788",
"assets/assets/google_fonts/Cousine/Cousine-BoldItalic.ttf": "410ff03998bfb1355fe65e240438173c",
"assets/assets/google_fonts/Cousine/LICENSE.txt": "d273d63619c9aeaf15cdaf76422c4f87",
"assets/assets/google_fonts/Cousine/Cousine-Regular.ttf": "ea28fb808e427a5eaac9639551ac38dc",
"assets/assets/google_fonts/Cousine/Cousine-Bold.ttf": "0cce26797769173fad6c80adbf30e36a",
"assets/assets/google_fonts/Cousine/Cousine-Italic.ttf": "3a48c1f3958d278bb678665eab4fe75d",
"assets/NOTICES": "5667c7ab4bf3c718aff53d7707ee74c0",
"assets/AssetManifest.bin": "5e2919d0c4cbf4c003e2c3b9149c30b7",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
