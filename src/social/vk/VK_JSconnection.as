/**
 * Created by andy on 3/2/18.
 */
package social.vk {
import com.junkbyte.console.Cc;

import flash.external.ExternalInterface;

public class VK_JSconnection {
    private var _func:Object;

    public function VK_JSconnection(initCallback:Function) {
        _func = {};
        if (ExternalInterface.available) {
            ExternalInterface.addCallback('onInit', initCallback);
            ExternalInterface.addCallback('onError', onError);
            ExternalInterface.addCallback('apiCallback', apiCallback);
        }
        ExternalInterface.call("vk_init");
    }
    
    public function onError(e:Object):void {
        if (e.message) Cc.ch('VK', 'ERROR:: ' + e.message);
    }

    public function api(method:String, params:Object, callback:Function, errorCallback:Function):void {
        var key:String = method + String(int(Math.random()*10000));
        _func[key] = {callback: callback, errorCallback: errorCallback};
        ExternalInterface.call("vk_api", {method: method, params: params, key: key});
    }

    public function apiCallback(e:Object):void {
        Cc.ch('VK', 'response from VK method:' + e.method);
        Cc.obj('VK', e);
        var ob:Object = _func[e.key];
        if (!ob) {
            Cc.ch('VK', 'wrong key with method: ' + e.method);
            return;
        }
        delete _func[e.key];
        if (e.message) {
            if (e.message == 'success') {
                Cc.ch('VK', 'apiCallback SUCCESS for: ' + e.method);
                if (ob.callback!=null) {
                    try {
                        ob.callback.apply(null, [e.result]);
                    } catch (e:Error) {
                        Cc.ch('VK', 'catch error: ' + e.message, 9);
                    }
                } else Cc.ch('VK', 'callback is NULL');
            } else if (e.message == 'error') {
                Cc.ch('VK', 'apiCallback error for: "' + e.method + '"  with error message: ' + e.error);
                if (ob.errorCallback!=null) {
                    ob.errorCallback.apply(null, [e.error]);
                } else Cc.ch('VK', 'errorCallback is NULL');
            }
        }
    }
}
}
