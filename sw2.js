// 10Б анги service worker (push дэмжинэ) v4
var CACHE="10b-v4";
self.addEventListener("install", function(e){ self.skipWaiting(); });
self.addEventListener("activate", function(e){ e.waitUntil(self.clients.claim()); });
self.addEventListener("fetch", function(e){
  var req = e.request;
  if (req.method !== "GET" || new URL(req.url).origin !== location.origin) return;
  e.respondWith(
    fetch(req).then(function(res){
      var copy = res.clone();
      caches.open(CACHE).then(function(c){ c.put(req, copy); });
      return res;
    }).catch(function(){ return caches.match(req).then(function(r){ return r || caches.match("./"); }); })
  );
});
self.addEventListener("push", function(e){
  var d={}; try{ d=e.data.json(); }catch(x){ try{ d={body:e.data.text()}; }catch(y){} }
  e.waitUntil(self.registration.showNotification(d.title||"10Б анги",{
    body:d.body||"", icon:"icon-192.png", badge:"icon-192.png", data:{tab:d.tab||"home"},
    vibrate:[250,120,250,120,250], tag:"10b-"+(d.tab||"home"), renotify:true, requireInteraction:false
  }));
});
self.addEventListener("notificationclick", function(e){
  e.notification.close();
  var tab=(e.notification.data&&e.notification.data.tab)||"home";
  e.waitUntil(self.clients.matchAll({type:"window",includeUncontrolled:true}).then(function(list){
    for(var i=0;i<list.length;i++){ if("focus" in list[i]){ list[i].postMessage({tab:tab}); return list[i].focus(); } }
    return self.clients.openWindow("./");
  }));
});
