'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "01eb2c11c2685e04a0e3b0556549b914",
".git/config": "0e0c2710abf37b5765eef6a22148373e",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "4cf2d64e44205fe628ddd534e1151b58",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "d34a630b63fe6ef5bcbb34e49072a924",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "0821a8e69f147fcba7079db7008ef0c0",
".git/logs/refs/heads/master": "0821a8e69f147fcba7079db7008ef0c0",
".git/logs/refs/remotes/origin/master": "c9486aae6ed978bbc100aa9e6da94a16",
".git/objects/01/1da9384c598a5561d86297da0645b5e9e26454": "e541decb1c9a83e33f27ee968f69b1b9",
".git/objects/01/5a0b09c3d98940470235c102f78d585a9eb86e": "4281850d52a65073593b558dc20a31bf",
".git/objects/1d/af4b77aa76f03d8fcbed75fe0351d9be5e6d05": "f660538c33640e751175254b937f3877",
".git/objects/1f/56f37f03ce85a12cf7c78e764b540a49f36693": "f30e32eb15689e3e5763dd4ae98c2782",
".git/objects/21/b0709991fa2923e77fe5e94d9e538cc635bc93": "67ac77f64523f9de59be2875667ea292",
".git/objects/35/91af41948adc8001f3586d76b91181311953fc": "c91d33b29071dcff3b2b3385383761cb",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/53/7807567919e88db2866b7825339c57e94c24d8": "970aec5149a3dbe9370a9dc982cdd022",
".git/objects/53/cdbc97c8891d68dd57d84b51dd97c87c8cc222": "b6d20245c6d17290bfc60191ca962be2",
".git/objects/54/f9e400aba76bab6242350fba64ec9b6aa6b92d": "4473020e86c810398f0b1ad943dac12e",
".git/objects/5a/fc6fe2e4265373bd5d1506c61d6b606a01e4ac": "95a05d6b59bd2f4fcfc424f87316588e",
".git/objects/67/b087f4c5b7bf462452717405a50850b90274ec": "96ab7423ac6b0604260505f1a3cb8148",
".git/objects/78/b634d82debb2262c40c45e9b8735d5f61d56e3": "c7982fbcfcb7117eda4fa093dcecfdee",
".git/objects/7a/349159908e56b3379f9d349014293fa04ecbcb": "8dfa58c2f561c1a3178b206ea89a0690",
".git/objects/7a/c778bd36b957c92e6cc6691b7108eb32cbed62": "04ded1e31853cfb88adad9986c48d040",
".git/objects/82/2c9c038a5ec6e285900aa0e7e253d9c0ae6940": "18aa6f1b33070c9e993554d9ea7f0569",
".git/objects/88/41101dc6d004f431d2c6e83507281435df3b87": "8c337191611895cc592145f6b082e9f5",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/9a/41f2cabd819f47fd7c06f47946c356a482599d": "3d11e088d00d27d2a95a0080849ec842",
".git/objects/9d/57502a8571143edbeaa7eeeaecf89c497377e3": "9fbbba4430d0f57f5e276b14269c13a1",
".git/objects/9d/5f886353dcff6c222439cc1118e77eb1b007ea": "a87ff240c6e149d1ce495643e49417f9",
".git/objects/aa/00824565eae4cce97ac9af79b0a54f5d138f64": "228d5f421de4df42cda944fa4f5a6756",
".git/objects/ae/c20641e8252b3d20ac47b244f90327ced86a63": "1c92583cb606313f8cf1ba0764816f46",
".git/objects/b4/0c7be6d7c4ed960d1dc5435e2ba3b19a5764ab": "eb5c9bb66c5a8e7253fb8af1b2292cb9",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/bb/6131bec2b7b2e6337635437576fa0f0cb38c74": "29b646128c752b0b2764d97f69a8f74d",
".git/objects/bb/ac29f5ef7a40bf14c0901bc1457724156bc0de": "1393f20f0610cabefe2d4f45865b0f54",
".git/objects/c2/d8d2f44dd987786bbc249d4ad7bac3360f4811": "1926a57b256d9def261ccf6dc2914f65",
".git/objects/ca/7004d4ac978cba17f6d0a36e1f62d39430bb38": "1f18712ec1d192bda16ada8e105786a2",
".git/objects/cc/f8b8c9a770d308701c766404320ffcab5757aa": "6385f5a6ffb2a2e62520177ec78489c1",
".git/objects/cd/f8605ad9d0062aa0c3e9dfe571fa35fbf4671f": "e9d4148e5be4e436a35fef68b40eab35",
".git/objects/d2/95fd52d0343565abdbc84abec859772aeafc56": "a046665bf06f113d7ccc40ac085ccfa5",
".git/objects/d3/efa7fd80d9d345a1ad0aaa2e690c38f65f4d4e": "610858a6464fa97567f7cce3b11d9508",
".git/objects/d5/b54bd4a898b373f82bb1fa52b9580e7a976e3e": "943e27e1d359e2bc22daf20c70287c19",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/2c11112c7cb4e2ce754bc41470f9b829a2d00a": "d7280a766a5d6033f187d874a92b5ad6",
".git/objects/d7/d6d7866cb09d5c1079b7e30e415f8084ef0683": "fe05f780367181956779802115a7fb9a",
".git/objects/df/2a0454c19b1a98eb94a261d9ebf7c6fd5dc846": "a285a6cbc41b75eac39a2cd2ab6752c1",
".git/objects/df/7d2dcb89ab89da87467c0e1059b38c8d8f9296": "a44162ff357b024e4638ab18a9bb01c7",
".git/objects/e0/49c81f7cb35ebc411a3e1b547bf4ccf91292e8": "efad70dc0ca77a90ee53b5cc3be528ca",
".git/objects/e2/ff5865b192241d53935e77de70a4e6dff2847a": "cad1058aedc6c21a518b3cb00af21fac",
".git/objects/e6/46d591f99adb142edab348e5d728ad2bddc4a3": "7630b34441d494db3bf4d884cd250e72",
".git/objects/e6/b745f90f2a4d1ee873fc396496c110db8ff0f3": "2933b2b2ca80c66b96cf80cd73d4cd16",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f2/cec5ffd417f4bc22b3f3d5fe6852264b2b45e5": "7fea66a78aecba639438300e27654b3e",
".git/objects/fc/de1bb3df8c330568f07ef326d43d8ae3562897": "6e5bf2450330342c243afc3723b9c27e",
".git/objects/fd/b4f4a2d68a6faced07a4f225fb98e73c41fbdb": "6545ceb7fb0bb07b5b262282d730f652",
".git/refs/heads/master": "72c54e9c6ce9a98323c379339b349020",
".git/refs/remotes/origin/master": "72c54e9c6ce9a98323c379339b349020",
"assets/AssetManifest.bin": "279915b7d3b36edbb2c2c161aa2326f0",
"assets/AssetManifest.json": "9fd48f2cd588d4a10db6265496d5cd98",
"assets/assets/images/asset.png": "af4a6929d9248c7fb93de82a0827f2f8",
"assets/assets/images/asset2.png": "24130ed7d2f8d898fcfb61339daa184d",
"assets/assets/images/category.png": "eab25cc3fded9ac8d3a26c6355c63c71",
"assets/assets/images/country.png": "6fa68dff25784869f4b27a9be3eeb970",
"assets/assets/images/delete.png": "de6afa9221f123b5846e8b6099693766",
"assets/assets/images/folder.png": "6e5054c8da7b78783f9a1c389c80443e",
"assets/assets/images/group.png": "b93c5551fdbe9e412c98c0d7fcc8d9d8",
"assets/assets/images/home.jpg": "6d587c7ae1ad89b55bd2b2ea55c3d352",
"assets/assets/images/logo.png": "71854c7a4018ffb6dce641b4b89e077e",
"assets/assets/images/tenant.png": "236650e6337a8cfce3f6e692ab807e1a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "0921b16ab3c7b958df2a96fac8485df8",
"assets/NOTICES": "2fe8ea95037e028f9644da51fc4474a9",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"canvaskit/canvaskit.js": "5caccb235fad20e9b72ea6da5a0094e6",
"canvaskit/canvaskit.wasm": "d9f69e0f428f695dc3d66b3a83a4aa8e",
"canvaskit/chromium/canvaskit.js": "ffb2bb6484d5689d91f393b60664d530",
"canvaskit/chromium/canvaskit.wasm": "393ec8fb05d94036734f8104fa550a67",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "6b515e434cea20006b3ef1726d2c8894",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "c400190872aed4f71f74dc1bc07f9c6b",
"/": "c400190872aed4f71f74dc1bc07f9c6b",
"main.dart.js": "9af88b09fa65098010a8964ba478af12",
"manifest.json": "0644252c67677ea6b0a74e41d949fc2b",
"version.json": "942fa55ff310c8ad3f83ae3c1ab0021c"};
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
