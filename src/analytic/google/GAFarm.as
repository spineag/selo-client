package analytic.google {
import com.junkbyte.console.Cc;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;

import manager.Vars;

import social.SocialNetwork;
import social.SocialNetworkSwitch;

import starling.events.Event;

public class GAFarm {
    private static const ACCOUNT_VK:String = "UA-78805451-1";
    private static const ACCOUNT_OK:String = "UA-78805451-2";
    private static const ACCOUNT_FB:String = "UA-78805451-3";
    private static const GA_URL:String = 'https://www.google-analytics.com/collect';
    private var _isActive:Boolean = false;

    private var g:Vars = Vars.getInstance();

    public function GAFarm() {
        try {
            if (!g.isDebug) _isActive = true;
            Cc.ch("analytic", "<GAFarm> initialized on");
        } catch (error:Error) {
            Cc.error("<GAFarm> init error:" + error.message);
        }
    }

    public function sendActivity(category:String, action:String, obj:Object):void {
        try {
            if (_isActive) {
                checkGAsid(category, action, obj);
            } else {
                Cc.ch('analytic', "<GAFarm> is not ready to send event");
            }
        } catch (error:Error) {
            Cc.error("<GAFarm> send activity error: " + error.message);
        }
    }

    private function checkGAsid(category:String, action:String, obj:Object):void {
        if (g.user.userGAcid == 'unknown' || g.user.userGAcid == 'undefined') {
            var f:Function = function():void {
                event(category, action, obj);
            };
            g.socialNetwork.getUserGAsid(f);
        } else {
            event(category, action, obj);
        }
    }

    private function event(category:String, action:String, obj:Object):void {
        if (g.user.userGAcid == 'unknown' || g.user.userGAcid == 'undefined') {
            Cc.ch('analytic', 'still wrong GAcid');
            return;
        }
        var loader:URLLoader = new URLLoader();
        var url:String = GA_URL;
        url += '?' + 'v=1';
        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            url += '&' + 'tid=' + ACCOUNT_VK;
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            url += '&' + 'tid=' + ACCOUNT_OK;
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            url += '&' + 'tid=' + ACCOUNT_FB;
        }
        url += '&' + 'cid=' + g.user.userGAcid;
        url += '&' + 't=' + 'event';
        url += '&' + 'ec=' + category;
        url += '&' + 'ea=' + action;
        url += '&' + 'el=' + obj.id;
        if (obj.info) url += '&' + 'ev=' + obj.info;
        url += '&' + 'z=' + int(Math.random()*1000000);
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        function onComplete(e:Event):void { Cc.obj('analytic', e, 'responce:: ', 1) };
        loader.addEventListener(Event.COMPLETE, onComplete);
        try {
            loader.load(request);
            Cc.ch("analytic", "<GAFarm> sending event => " + category + " + " + action);
        } catch (error:Error) {
            Cc.error("<GAFarm> send event error: " + error.message);
        }
    }
}
}
