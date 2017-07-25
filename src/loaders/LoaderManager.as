package loaders {
import com.deadreckoned.assetmanager.Asset;

import loaders.allLoadMb.AllLoadMb;

import manager.*;

import com.deadreckoned.assetmanager.AssetManager;
import com.deadreckoned.assetmanager.AssetQueue;
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import flash.display.BitmapData;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class LoaderManager {
    private static const COUNT_PARALEL_LOADERS:int = 25;

    [ArrayElementType('com.deadreckoned.assetmanager.AssetQueue')]
    private var _loaders:Array;
    private var _loaderQueue:AssetQueue;

    private var _loader:AssetManager = AssetManager.getInstance();
    private var _callbacks:Object;
//    private var _loadMb:AllLoadMb;
    //если элемент пошел на загрузку, но еще не загрузился
    private var additionalQueue:Object = new Object();

    private static var _instance:LoaderManager;

    protected var g:Vars = Vars.getInstance();

    public static function getInstance():LoaderManager {
        if (!_instance) {
            _instance = new LoaderManager(new SingletonEnforcer());
        }
        return _instance;
    }

    public function LoaderManager(se:SingletonEnforcer) {
        if (!se) {
            Cc.error('Use LoaderManager.getInstance() instead!!');
        }

        _loaders = [];
        _callbacks = {};
//        _loadMb = new AllLoadMb();
        _loader.loadSequentially = true;
        _loaderQueue = _loader.createQueue('loader');
        _loaderQueue.loadSequentially = false;
        for (var i:int = 0; i < COUNT_PARALEL_LOADERS; i++) {
            _loaders.push(_loader.createQueue('loader' + String(i)));
        }
    }
    
    public function removeByUrl(url:String):void {
        if (_loaderQueue) _loaderQueue.removeByUrl(url);
    }

    public function loadImage(url:String, callback:Function = null, ...callbackParams):void {
        if (url == '' || url == null) return;

        Cc.ch('load', 'try to load image: ' + url);
        if (g.pBitmaps[url]) {
            setCallback(url, callback, callbackParams);
            getCallback(url);
            return;
        }

        if (!additionalQueue[url]) {
            additionalQueue[url] = new Array();  // первый элемент пропускаем, чтобы не было двойного колбека на него
        } else {
            additionalQueue[url].push({callback: callback, callbackParams: callbackParams});
        }

        _loaderQueue.add(url, {type: AssetManager.TYPE_IMAGE, priority: 8, onComplete: loadedImage, onCompleteParams: [url, callback, callbackParams], onError: errorHandler, onErrorParams: [url]});
    }

    private function loadedImage(url:String, callback:Function, callbackParams:Array):void {
        var bitmapData:BitmapData;
        var b:Bitmap;
        bitmapData = _loader.get(url).asset;
        b = new Bitmap(bitmapData, 'auto', true);
        Cc.ch('load', 'on load image: ' + url);

        g.pBitmaps[url] = new PBitmap(b);
        loadMb(url);
        
        if (callback != null) {
            if (b != null) {
                callback.apply(null, [g.pBitmaps[url].create() as Bitmap].concat(callbackParams));
            } else {
                Cc.error(url, 'load with some problem.')
            }
        }

        if (additionalQueue[url] && additionalQueue[url].length && g.pBitmaps[url]) {
            for (var i:int = 0; i < additionalQueue[url].length; i++) {
                if (additionalQueue[url][i].callback != null) {
                    additionalQueue[url][i].callback.apply(null, [g.pBitmaps[url].create() as Bitmap].concat(additionalQueue[url][i].callbackParams))
                }
            }
        }
        if (additionalQueue[url]) additionalQueue[url] = null;
    }

    public function loadXML(url:String, callback:Function = null, ...callbackParams):void {
        if (url == '') return;

        Cc.ch('load', 'try to load xml: ' + url);
        if (g.pXMLs[url]) {
            setCallback(url, callback, callbackParams);
            getCallback(url);
            return;
        }

        if (!additionalQueue[url]) {
            additionalQueue[url] = new Array();  // первый элемент пропускаем, чтобы не было двойного колбека на него
        } else {
            additionalQueue[url].push({callback: callback, callbackParams: callbackParams});
        }

        _loaderQueue.add(url, {type: AssetManager.TYPE_XML, priority: 8, onComplete: loadedXML, onCompleteParams: [url, callback, callbackParams], onError: errorHandler, onErrorParams: [url]});
    }

    private function loadedXML(url:String, callback:Function, callbackParams:Array):void {
        var xml:XML = XML(_loader.get(url).asset);
        Cc.ch('load', 'on load xml: ' + url);

        g.pXMLs[url] = xml;
        loadMb(url);
        
        if (callback != null) {
            callback.apply(null, callbackParams);
        }

        if (additionalQueue[url] && additionalQueue[url].length) {
            for (var i:int = 0; i < additionalQueue[url].length; i++) {
                if (additionalQueue[url][i].callback != null) {
                    additionalQueue[url][i].callback.apply(null, additionalQueue[url][i].callbackParams);
                }
            }
        }

        if (additionalQueue[url]) additionalQueue[url] = null;
    }

    public function loadJSON(url:String, callback:Function = null, ...callbackParams):void {
        if (url == '') return;

        Cc.ch('load', 'try to load json: ' + url);
        if (g.pXMLs[url]) {
            setCallback(url, callback, callbackParams);
            getCallback(url);
            return;
        }

        if (!additionalQueue[url]) {
            additionalQueue[url] = new Array();  // первый элемент пропускаем, чтобы не было двойного колбека на него
        } else {
            additionalQueue[url].push({callback: callback, callbackParams: callbackParams});
        }

        _loaderQueue.add(url, {type: AssetManager.TYPE_JSON, priority: 8, onComplete: loadedJSON, onCompleteParams: [url, callback, callbackParams], onError: errorHandler, onErrorParams: [url]});
    }

    private function loadedJSON(url:String, callback:Function, callbackParams:Array):void {
        Cc.ch('load', 'on load json: ' + url);
        g.pJSONs[url] = _loader.get(url).asset;
        loadMb(url);
        
        if (callback != null) {
            callback.apply(null, callbackParams);
        }

        if (additionalQueue[url] && additionalQueue[url].length) {
            for (var i:int = 0; i < additionalQueue[url].length; i++) {
                if (additionalQueue[url][i].callback != null) {
                    additionalQueue[url][i].callback.apply(null, additionalQueue[url][i].callbackParams);
                }
            }
        }
        if (additionalQueue[url]) additionalQueue[url] = null;
    }

    public function loadAtlas(url:String, name:String, f:Function, ...params):void {
        var count:int = 2;
        var st:String = g.dataPath.getGraphicsPath() + url;
        var v:String = g.getVersion(name);
        var fOnLoad:Function = function(smth:*=null):void {
            count--;
            if (count<=0) {
                g.allData.atlas[name] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + '.png' + v].create() as Bitmap), g.pXMLs[st + '.xml' + v]);
                (g.pBitmaps[st + '.png' + v] as PBitmap).deleteIt();
                delete  g.pBitmaps[st + '.png' + v];
                delete  g.pXMLs[st + '.xml' + v];
                removeByUrl(st + '.png' + v);
                removeByUrl(st + '.xml' + v);
                if (f!=null) f.apply(null, params);
            }
        };
        loadImage(st + '.png' + v, fOnLoad);
        loadXML(st + '.xml' + v, fOnLoad);
    }

    public function loadSWFModule(url:String, callback:Function, ...callbackParams):void {
        setCallback(url, callback, callbackParams);
        _loaderQueue.add(url, {type: AssetManager.TYPE_SWF, priority: 8, onComplete: loadedSWFModule, onCompleteParams: [url], onError: errorHandler, onErrorParams: [url]});
    }

    public function loadMb(url:String):void {
        g.loadMb.array.push(_loader.get(url).bytesTotal);
    }

    private function loadedSWFModule(url:String):void {
        getCallback(url, _loader.get(url).rawData);
    }

    private function errorHandler(url:String):void {
        Cc.error('LoaderManager:: error at ' + url);
    }

    private function setCallback(key:String, callback:Function, callbackParams:Array):void {
        if (callback != null) {
            if (_callbacks[key] == undefined) {
                _callbacks[key] = [{callback: callback, callbackParams: callbackParams}];
            } else {
                _callbacks[key].push({callback: callback, callbackParams: callbackParams});
            }
        }
    }

    private function getCallback(url:String, extraData:* = null):void {
        var callbackObject:Object;

        if (_callbacks[url] != undefined) {
            while (_callbacks[url] && _callbacks[url].length) {
                callbackObject = _callbacks[url].pop();
                var arr:Array;
                if (extraData) {
                    arr = [extraData];
                } else {
                    if (g.pBitmaps[url]) arr = [g.pBitmaps[url].create() as Bitmap];
                    else arr = [null];
                }
                if (callbackObject.callback != null) {
                    callbackObject.callback.apply(null, arr.concat(callbackObject.callbackParams));
                }
            }
            delete _callbacks[url];
        }
    }

    public function get loader():AssetManager {
        return _loader;
    }

}
}class SingletonEnforcer {}