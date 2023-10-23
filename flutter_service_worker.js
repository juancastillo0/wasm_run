'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"index.html": "8b1f12d1f895773033240120e69675b0",
"/": "8b1f12d1f895773033240120e69675b0",
"version.json": "6d04cb54e307c269ac10de742cfd1f67",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/AssetManifest.bin": "dbfdb733594b0a4eb0d4b6b2e514c009",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/rust_crypto/lib/assets/rust_crypto_wasm.wasm": "14534e63438ba10c961e08b595b6fdf7",
"assets/packages/compression_rs/lib/assets/compression_rs_wasm.threads.wasm": "6275a3402960142f22089e2637bbeb9f",
"assets/packages/compression_rs/lib/assets/compression_rs_wasm.wasm": "8b4d76dfb3af94ee9e2cfefae1fe4338",
"assets/packages/compression_rs/lib/assets/compression_rs_wasm.brotli.threads.wasm": "b299006721a7ff55f5fe740197f11390",
"assets/packages/wasm_parser/lib/assets/wasm_parser_wasm.threads.wasm": "3be3bc21ee096503e103194a3e2146db",
"assets/packages/wasm_parser/lib/assets/wasm_parser_wasm.wasm": "44713a36ff804554b9d0a9c110cdff3f",
"assets/packages/sql_parser/assets/sql_parser_wasm.wasm": "8878571c71257a703649c640b38264d8",
"assets/packages/sql_parser/lib/assets/sql_parser_wasm.wasm": "8878571c71257a703649c640b38264d8",
"assets/packages/wasm_wit_component/lib/dart_wit_component.wasm": "a9a0d7d9e538cdd1bdea5a8c098f0264",
"assets/packages/image_rs/lib/assets/image_rs_wasm.wasm": "d52c060b4a28be14d611714d39910caa",
"assets/packages/wasm_run/lib/assets/wasm-feature-detect.js": "fbba857d68dfbf499b84606326f6c942",
"assets/packages/wasm_run/lib/assets/wasm.worker.js": "100dc1f86c19f6ddcc6ddf64d81388df",
"assets/packages/wasm_run/lib/assets/browser_wasi_shim.js": "91ba950eb53119a764eecec75ed5bdb5",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/fonts/MaterialIcons-Regular.otf": "5842aa3758e3237e6f2095fbb3543c28",
"assets/AssetManifest.bin.json": "bc2b565d4c906a9c9fd05f537f234ff7",
"assets/assets/google_fonts/Cousine/Cousine-BoldItalic.ttf": "410ff03998bfb1355fe65e240438173c",
"assets/assets/google_fonts/Cousine/LICENSE.txt": "d273d63619c9aeaf15cdaf76422c4f87",
"assets/assets/google_fonts/Cousine/Cousine-Italic.ttf": "3a48c1f3958d278bb678665eab4fe75d",
"assets/assets/google_fonts/Cousine/Cousine-Bold.ttf": "0cce26797769173fad6c80adbf30e36a",
"assets/assets/google_fonts/Cousine/Cousine-Regular.ttf": "ea28fb808e427a5eaac9639551ac38dc",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/NOTICES": "6ee9f627b040fc3e01c8dd1d29c8000f",
"assets/AssetManifest.json": "eee1f918127e4ec37ced53cba1e27892",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/canvaskit.wasm": "64edb91684bdb3b879812ba2e48dd487",
"canvaskit/chromium/canvaskit.wasm": "f87e541501c96012c252942b6b75d1ea",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/skwasm.wasm": "4124c42a73efa7eb886d3400a1ed7a06",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"manifest.json": "9fd6ef9f20407e8b95a48e040ff54627",
"flutter.js": "7d69e653079438abfbb24b82a655b0a4",
"sqlite3.wasm": "2068781fd3a05f89e76131a98da09b5b",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"main.dart.js": "2942c078a297027a7ede235bb5240d28"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
