/**
 * Created by user on 7/16/15.
 */
package server {
import additional.pets.PetMain;

import build.WorldObject;
import build.decor.DecorTail;
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.ridge.Ridge;
import build.train.Train;
import build.tree.Tree;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import data.StructureDataAnimal;
import data.StructureDataBuilding;
import data.StructureDataPet;
import data.StructureMarketItem;
import data.StructureDataRecipe;
import data.StructureDataResource;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.getTimer;
import manager.ManagerAnimal;
import manager.ManagerFabricaRecipe;
import manager.ManagerPlantRidge;
import manager.ManagerTree;
import manager.Vars;
import mouse.ServerIconMouse;
import quest.QuestTaskStructure;
import social.SocialNetworkSwitch;
import user.Someone;

import utils.TimeUtils;
import utils.Utils;
import windows.WindowsManager;
import com.adobe.crypto.MD5;
import windows.gameError.PreloadInfoTab;

public class DirectServer {
    private var g:Vars = Vars.getInstance();
    private var iconMouse:ServerIconMouse = new ServerIconMouse();
    private var SECRET:String = '505';

    private function addDefault(variables:URLVariables):URLVariables {
        if (g.user && g.user.sessionKey) variables.sessionKey = g.user.sessionKey;
        variables.channelId = g.socialNetworkID;
        return variables;
    }

    public function getVersion(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_VERSION);

        Cc.ch('server', 'start getVersion', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteVersion);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getVersion'); } );
        function onCompleteVersion(e:Event):void { completeVersion(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataRecipe error:' + error.errorID);
        }
    }

    private function completeVersion(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getVersion: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getVersion OK', 5);
            for (var i:int = 0; i<d.message.length; i++) {
                g.version[d.message[i].name] = d.message[i].version;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getVersion: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
        }
    }


    public function getTextHelp(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_TEXT_HELP);

        Cc.ch('server', 'start getTextHelp', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetTextHelp);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getTextHelp'); });
        function onCompleteGetTextHelp(e:Event):void { completeGetTextHelp(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getTextHelp error:' + error.errorID);
        }
    }

    private function completeGetTextHelp(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getTextHelp: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getTextHelp OK', 5);
            var randomPos:int  = int(Math.random() * d.message.length);
//            g.startPreloader.textHelp(String(d.message[randomPos].text));
//            g.startPreloader.textHelp(String(g.managerLanguage.allTexts[d.message[randomPos].text_id]));
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getTextHelp: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
        }
    }


    public function getDataLevel(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_LEVEL);

        Cc.ch('server', 'start getDataLevel', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAllLevels);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataLevel'); });
        iconMouse.startConnect();
        function onCompleteAllLevels(e:Event):void { completeLevels(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataLevel error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeLevels(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('loadLevels: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'loadLevels: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataLevel OK', 5);
            var obj:Object;
            var k:int;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].number_level);
                obj.xp = int(d.message[i].count_xp);
                obj.totalXP = int(d.message[i].total_xp);
                obj.countSoft = int(d.message[i].count_soft);
                obj.countHard = int(d.message[i].count_hard);
                if (d.message[i].decor_id) obj.decorId = String(d.message[i].decor_id).split('&');
                for (k = 0; k < obj.decorId.length; k++) obj.decorId[k] = int(obj.decorId[k]);
                if (d.message[i].resource_id) obj.resourceId = String(d.message[i].resource_id).split('&');
                for (k = 0; k < obj.resourceId.length; k++) obj.resourceId[k] = int(obj.resourceId[k]);
                if (d.message[i].count_decor) obj.countDecor = String(d.message[i].count_decor).split('&');
                for (k = 0; k < obj.countDecor.length; k++) obj.countDecor[k] = int(obj.countDecor[k]);
                if (d.message[i].count_resource) obj.countResource = String(d.message[i].count_resource).split('&');
                for (k = 0; k < obj.countResource.length; k++) obj.countResource[k] = int(obj.countResource[k]);
                obj.catCount = int(d.message[i].cat_count);
                obj.ridgeCount = int(d.message[i].ridge_count);
                g.dataLevel.objectLevels[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('loadLevels: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'loadLevels: id: ' + d.id + '  with message: ' + d.message);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);

        }
    }

    public function getDataAnimal(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_ANIMAL);

        Cc.ch('server', 'start getDataAnimal', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataAnimal'); });
        function onCompleteAnimal(e:Event):void { completeAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAnimal(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataAnimal: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataAnimal: wrong JSON:' + String(response));
            return;
        }
        var k:int = 0;
        if (d.id == 0) {
            Cc.ch('server', 'getDataAnimal OK', 5);
            for (var i:int = 0; i<d.message.length; i++) {
                g.allData.registerAnimal( new StructureDataAnimal(d.message[i]) );
                
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataAnimal: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getDataPet(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_PET);

        Cc.ch('server', 'start getDataPet', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompletePet);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataPet'); });
        function onCompletePet(e:Event):void { completePet(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataPet error:' + error.errorID);
        }
    }

    private function completePet(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataPet: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataPet: wrong JSON:' + String(response));
            return;
        }
        var k:int = 0;
        if (d.id == 0) {
            Cc.ch('server', 'getDataPet OK', 5);
            for (var i:int = 0; i<d.message.length; i++) {
                g.allData.registerPet( new StructureDataPet(d.message[i]) );
            }
            if (callback != null) callback.apply();
        } else {
            Cc.error('getDataPet: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getDataRecipe(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_RECIPE);

        Cc.ch('server', 'start getDataRecipe', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteRecipe);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataRecipe'); });
        function onCompleteRecipe(e:Event):void { completeRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataRecipe error:' + error.errorID);
        }
    }

    private function completeRecipe(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataRecipe: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataRecipe: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataRecipe OK', 5);
            for (var i:int = 0; i<d.message.length; i++) {
                g.allData.registerRecipe( new StructureDataRecipe(d.message[i]) );
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataRecipe: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getDataResource(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_RESOURCE);

        Cc.ch('server', 'start getDataResource', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteResource);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataResource'); });
        function onCompleteResource(e:Event):void { completeResource(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataResource error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);

        }
    }

    private function completeResource(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataResource: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataResource: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataResource OK', 5);
            var obj:Object;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].id);
                obj.blockByLevel = int(d.message[i].block_by_level);
                obj.priceHard = int(d.message[i].cost_hard);
                obj.name = d.message[i].name;
                obj.url = d.message[i].url;
                obj.imageShop = d.message[i].image_shop;
                obj.currency = int(d.message[i].currency);
                obj.costDefault = int(d.message[i].cost_default);
                obj.costMax = int(d.message[i].cost_max);
                obj.orderPrice = int(d.message[i].order_price);
                obj.orderXP = int(d.message[i].order_xp);
                obj.visitorPrice = int(d.message[i].visitor_price);
                obj.buildType = int(d.message[i].resource_type);
                obj.placeBuild = int(d.message[i].resource_place);
                obj.orderType = int(d.message[i].order_type);
                obj.opys = d.message[i].descript;
                if (d.message[i].cost_skip) obj.priceSkipHard = d.message[i].cost_skip;
                if (d.message[i].build_time) obj.buildTime = d.message[i].build_time;
                if (d.message[i].craft_xp) obj.craftXP = d.message[i].craft_xp;
//                g.dataResource.objectResources[obj.id] = obj;
                g.allData.registerResource( new StructureDataResource(d.message[i]) );
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataResource: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataResource: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataCats(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_CATS);

        Cc.ch('server', 'start getDataCats', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteCats);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataCats'); });
        function onCompleteCats(e:Event):void { completeCats(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataCats error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);

        }
    }

    private function completeCats(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataCats: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataCats: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataCats OK', 5);
            var obj:Object;
            g.dataCats = new Array();
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].id);
                obj.blockByLevel = [int(d.message[i].block_by_level)];
                obj.cost = int(d.message[i].cost);
                obj.currency == DataMoney.SOFT_CURRENCY
                g.dataCats.push(obj);
            }
            g.dataCats.sortOn('blockByLevel', Array.NUMERIC);
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataResource: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataResource: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataInviteViral(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_VIRAL_INVITE);

        Cc.ch('server', 'start getDataInviteViral', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompletegetDataInviteViral);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataInviteViral'); });
        function onCompletegetDataInviteViral(e:Event):void { completegetDataInviteViral(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataInviteViral error:' + error.errorID);
        }
    }

    private function completegetDataInviteViral(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataInviteViral: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataInviteViral: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataInviteViral OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else {
            Cc.error('getDataInviteViral: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getDataBuyMoney(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_BUY_MONEY);

        Cc.ch('server', 'start getDataBuyMoney', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataBuyMoney);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataBuyMoney'); });
        function onCompleteGetDataBuyMoney(e:Event):void { completeGetDataBuyMoney(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataBuyMoney error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetDataBuyMoney(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var k:int = 0;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataBuyMoney: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataBuyMoney: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataBuyMoney OK', 5);
            var obj:Object;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].id);
                obj.typeMoney = int(d.message[i].type_money);
                obj.cost = Number(d.message[i].cost_for_real);
                obj.count = int(d.message[i].count_getted);
                obj.url = d.message[i].url;
                obj.sale = d.message[i].sale;
                if (d.message[i].bonus) {
                    obj.bonus = String(d.message[i].bonus).split('&');
                    for (k = 0; k < obj.bonus.length; k++) obj.bonus[k] = int(obj.bonus[k]);
                }
                g.allData.dataBuyMoney.push(obj);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataBuyMoney: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataBuyMoney: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDailyGift(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_DAILY_GIFT);

        Cc.ch('server', 'start getDailyGift', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDailyGift);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDailyGift'); });
        function onCompleteGetDailyGift(e:Event):void { completeGetDailyGift(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDailyGift error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetDailyGift(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDailyGift: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDailyGift: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDailyGift OK', 5);
            if (!g.user.useDailyGift) {
                g.user.useDailyGift=true;
                g.windowsManager.openWindow(WindowsManager.WO_DAILY_GIFT, null, d.message);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDailyGift: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataBuyMoney: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataBuilding(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_BUILDING);

        Cc.ch('server', 'start getDataBuilding', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataBuilding'); });
        function onCompleteBuilding(e:Event):void { completeBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuilding(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataBuilding: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataBuilding: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataBuilding OK', 5);
            for (var i:int = 0; i<d.message.length; i++) {
                d.message[i].visibleAction = true;
                if (g.user.isTester) g.allData.registerBuilding( new StructureDataBuilding(d.message[i]) );
                else if (d.message[i].visible == 0 ) {
                    var startDayNumber:int = int(d.message[i].start_action);
                    var endDayNumber:int = int(d.message[i].end_action);
                    var curDayNumber:int = TimeUtils.currentSeconds;

                    d.message[i].visibleAction = false;
                    if (startDayNumber == 0 && endDayNumber == 0) {
                        d.message[i].visibleAction = true;
                    } else {
                        if (startDayNumber != 0 && startDayNumber <= curDayNumber) {
                            if (endDayNumber > curDayNumber || endDayNumber == 0) {
                                d.message[i].visibleAction = true;
                            }
                            else {
                                d.message[i].visibleAction = false;
                            }
                        } else if (startDayNumber > curDayNumber) {
                            d.message[i].visibleAction = false;
                        }

                    }
                    g.allData.registerBuilding( new StructureDataBuilding(d.message[i]) );
                }
            }
            g.allData.sortDecorData();
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataBuilding: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function authUser(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_START);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'authUser', 1);
        g.user.sessionKey = String(int(Math.random()*1000000));
        variables = addDefault(variables);
        variables.idSocial = g.user.userSocialId;
        variables.name = g.user.name;
        variables.lastName = g.user.lastName;
        variables.sex = g.user.sex;
        variables.defaultLanguage = g.socialNetwork.checkLocaleForLanguage();
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            variables.timezone =  g.user.timezone;
            variables.photo = g.user.photo;
        }
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAuthUser);
        loader.addEventListener(IOErrorEvent.IO_ERROR,  function(ev:Event):void { internetNotWork('authUser'); });
        function onCompleteAuthUser(e:Event):void { completeAuthUser(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('authUser error:' + error.errorID);
        }
    }

    private function completeAuthUser(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('authUser: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'authUser OK', 5);
            g.user.userId = int(d.message);
            Cc.info('userID:: ' + g.user.userId);
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('authUser: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            if (g.windowsManager)g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getUserInfo(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_INFO);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserInfo', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUserInfo);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserInfo'); });
        function onCompleteUserInfo(e:Event):void { completeUserInfo(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('userInfo error:' + error.errorID);
        }
    }

    private function completeUserInfo(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('userInfo: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userInfo: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserInfo OK', 5);
            var ob:Object = d.message;
            var check:int = int(ob.ambar_max) + int(ob.sklad_max) + int(ob.ambar_level) + int(ob.sklad_level) + int(ob.hard_count) + int(ob.soft_count) +
                    int(ob.yellow_count) + int(ob.green_count) + int(ob.red_count) + int(ob.blue_count) + int(ob.level) + int(ob.xp) + int(ob.count_cats) +
                    int(ob.tutorial_step) + int(ob.count_chest) + int(ob.count_daily_bonus);
            if (check != int(ob.test_date)) {
                wrongDataFromServer('getUserInfo');
                return;
            }
            g.user.ambarLevel = int(ob.ambar_level);
            g.userValidates.updateInfo('ambarLevel', g.user.ambarLevel);
            g.user.skladLevel = int(ob.sklad_level);
            g.userValidates.updateInfo('skladLevel', g.user.skladLevel);
            g.user.ambarMaxCount = g.user.ambarLevel*25 + 25;
            g.user.skladMaxCount = g.user.skladLevel*25 + 25;
            g.user.hardCurrency = int(ob.hard_count);
            g.userValidates.updateInfo('hardCount', g.user.hardCurrency);
            g.user.softCurrencyCount = int(ob.soft_count);
            g.userValidates.updateInfo('softCount', g.user.softCurrencyCount);
            g.user.redCouponCount = int(ob.red_count);
            g.userValidates.updateInfo('redCount', g.user.redCouponCount);
            g.user.yellowCouponCount = int(ob.yellow_count);
            g.userValidates.updateInfo('yellowCount', g.user.yellowCouponCount);
            g.user.blueCouponCount = int(ob.blue_count);
            g.userValidates.updateInfo('softCount', g.user.softCurrencyCount);
            g.user.greenCouponCount = int(ob.green_count);
            g.userValidates.updateInfo('greenCount', g.user.greenCouponCount);
            g.user.blueCouponCount = int(ob.blue_count);
            g.userValidates.updateInfo('blueCount', g.user.blueCouponCount);
            g.user.globalXP = int(ob.xp);
            g.user.notif.onGetFromServer(ob.notification_new);
            g.user.starterPack = int(ob.starter_pack);
            if (g.user.starterPack == 0) {
                g.user.timeStarterPack = int(ob.time_starter_pack);
                g.userTimer.starterToEnd(g.user.timeStarterPack);
            } else g.user.timeStarterPack=0;
//            g.user.salePack = Boolean(int(ob.sale_pack));
            g.user.dayDailyGift  = int(ob.day_daily_gift);
            g.user.countDailyGift  = int(ob.count_daily_gift);
            g.user.language = int(ob.language);
            g.user.missDate = int(ob.miss_date);
            g.user.day = int (ob.day);
            g.user.cafeEnergyCount = int (ob.cafe_energy);
            g.user.cafeEnergyTime = int (ob.cafe_time_energy);
            g.user.coinsMax = int (ob.coins_max);
            g.user.countStand = int (ob.count_stand);
            g.user.decorCount = int (ob.decor_count);
            if (ob.announcement) g.user.announcement = Boolean(ob.announcement == '1');
            if (ob.next_time_invite) g.user.nextTimeInvite = int(ob.next_time_invite);
            if (!g.isDebug) {
                if (ob.music == '1') g.soundManager.enabledMusic(true);
                    else g.soundManager.enabledMusic(false);
                if (ob.sound == '1') g.soundManager.enabledSound(true);
                    else g.soundManager.enabledSound(false);
            }
            else {
                g.soundManager.enabledMusic(false);
                g.soundManager.enabledSound(false);
            }
            if (int(ob.time_paper) == 0) g.userTimer.timerAtPapper = 0;
                else g.userTimer.timerAtPapper = 300 - TimeUtils.currentSeconds - int(ob.time_paper);
            if (g.userTimer.timerAtPapper > 300) g.userTimer.timerAtPapper = 300;
            if (g.userTimer.timerAtPapper > 0)  g.userTimer.startUserPapperTimer(g.userTimer.timerAtPapper);

//            g.userTimer.papperTimerAtMarket = 0;

            g.user.tutorialStep = int(ob.tutorial_step);
            g.user.marketCell = int(ob.market_cell);
            if (ob.wall_order_item_time == int(new Date().dateUTC)) g.user.wallOrderItem = false;
                else g.user.wallOrderItem = true;

            if (ob.wall_train_item == int(new Date().dateUTC)) g.user.wallTrainItem = false;
                else g.user.wallTrainItem = true;

            g.user.level = int(ob.level);
            g.userValidates.updateInfo('level', g.user.level);

            g.user.checkUserLevel();
            if (ob.mouse_day) g.managerMouseHero.fillFromServer(ob.mouse_day, ob.mouse_count);
                else g.user.countAwayMouse = 0;

            g.managerDailyBonus.fillFromServer(ob.daily_bonus_day, int(ob.count_daily_bonus));
            g.managerChest.fillFromServer(ob.chest_day, int(ob.count_chest));
            if (ob.scale) g.currentGameScale = int(ob.scale) / 100;
            if (ob.cut_scene && ob.cut_scene.length < 10) {
                g.user.cutScenes = Utils.intArray( Utils.convert16to2(ob.cut_scene).split('') );
            } else g.user.cutScenes = [];
            Cc.info('User cutscenes: ');
            Cc.obj('info', g.user.cutScenes);
            if (ob.mini_scene) {
                Cc.info('User miniscenes:: ' + ob.mini_scene);
                if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
                    g.user.miniScenes = Utils.intArray( String(ob.mini_scene).split('&') );
                } else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID || g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID ) {
                    g.user.miniScenes = Utils.intArray( Utils.convert16to2(ob.mini_scene).split('') );
                    Cc.info('g.user.miniScenes: ' + g.user.miniScenes.join(' - '));
                }
                if (!g.user.miniScenes) g.user.miniScenes = [];
            } else g.user.miniScenes = [];

            if (ob.news_new) g.user.newsNew = Utils.intArray( String(ob.news_new).split('&') );
            else g.user.newsNew = [];

            g.user.miniScenesOrderCats = Utils.intArray( String(ob.order_cat_scene).split('') );

            g.user.isOpenOrder = Boolean(ob.open_order == '1');

            if (ob.is_tester && int(ob.is_tester) > 0) {
                g.user.isTester = true;
                if (int(ob.is_tester) > 1) g.user.isMegaTester = true;
            } else {
                g.user.isMegaTester = false;
                g.user.isTester = false;
            }

            if (callback != null) callback.apply();
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('userInfo: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserTutorialStep(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TUTORIAL_STEP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTutorialStep', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.step = g.user.tutorialStep;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.step)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onUpdateUserTutorialStep);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserTutorialStep'); });
        function onUpdateUserTutorialStep(e:Event):void { completeUpdateUserTutorialStep(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTutorialStep error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTutorialStep(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTutorialStep: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTutorialStep: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTutorialStep OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTutorialStep: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTutorialStep: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserTester(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TESTER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTester', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.isTester = g.user.isTester;
        variables.hash = MD5.hash(String(g.user.userId)+String(g.user.isTester)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteUpdateUserTester);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserTester'); });
        function onСompleteUpdateUserTester(e:Event):void { completeUpdateUserTester(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTester error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTester(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTester: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTester: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTester OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTester: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTutorialStep: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateStarterPack(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_STARTER_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTester', 1);
        variables = addDefault(variables);
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteUpdateStarterPack);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateStarterPack'); });
        function onСompleteUpdateStarterPack(e:Event):void { completeUpdateStarterPack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTester error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateStarterPack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTester: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTester: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTester OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTester: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTutorialStep: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getAllFriendsInfo(userSocialIdArr:Array, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ALL_FRIENDS_INFO);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getAllFriendsInfo', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.userSocialIds = userSocialIdArr.join('&');
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAllFriendsInfo);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getAllFriendsInfo'); });
        function onCompleteAllFriendsInfo(e:Event):void { completeAllFriendsInfo(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getAllFriendsInfo error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAllFriendsInfo(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getAllFriendsInfo: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllFriendsInfo: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getAllFriendsInfo OK', 5);
            g.user.addInfoAboutFriendsFromServer(d.message);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getAllFriendsInfo: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllFriendsInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserMoney(type:int, countAll:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_MONEY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserMoney', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.type = type;
        variables.countAll = countAll;
        variables.hash = MD5.hash(String(g.user.userId)+String(type)+String(countAll)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserMoney);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserMoney'); });
        function onCompleteAddUserMoney(e:Event):void { completeAddUserMoney(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserMoney error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserMoney(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserMoney: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserMoney: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserMoney OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('addUserMoney: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserMoney: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserXP(countAll:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_XP);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'addUserXP', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.countAll = countAll;
        variables.hash = MD5.hash(String(g.user.userId)+String(countAll)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserXP);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserXP'); });
        function onCompleteAddUserXP(e:Event):void { completeAddUserXP(e.target.data, countAll, callback,loader); }

        try {
            loader.load(request);
        } catch (error:Error) {
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserXP(response:String, countXP:int, callback:Function = null, loader:URLLoader = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserXP: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserXP: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserXP OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserXP: id: ' + d.id + '  with message: ' + d.message + d.status + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function updateUserLevel(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_LEVEL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserLevel', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.level = g.user.level;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.level)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserLevel);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserLevel'); });
        function onCompleteUpdateUserLevel(e:Event):void { completeUpdateUserLevel(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserLevel error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserLevel(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserLevel: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserLevel: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserLevel OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserLevel: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserLevel: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function updateUserTimePaper(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TIMER_PAPER);
        var variables:URLVariables = new URLVariables();
//        var time:Number = getTimer();
        Cc.ch('server', 'updateUserTimerPaper', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.timePaper = TimeUtils.currentSeconds;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.timePaper)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTimePaper);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserTimePaper'); });
        function onCompleteUpdateUserTimePaper(e:Event):void { completeUpdateUserTimePaper(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTimerPaper error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTimePaper(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTimerPaper: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTimerPaper: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTimerPaper OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTimerPaper: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTimerPaper: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserResource(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_RESOURCE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserResource', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserResource);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserResource'); });
        function onCompleteGetUserResource(e:Event):void { completeGetUserResource(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserResource error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserResource(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
            for (var i:int = 0; i < d.message.length; i++) {
                g.userInventory.addResourceFromServer(int(d.message[i].resource_id), int(d.message[i].count));
            }
        } catch (e:Error) {
            Cc.error('GetUserResource: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserResource: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserResource OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserResource: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserResource: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserResource(resourceId:int, count:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_RESOURCE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserResource', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.resourceId = resourceId;
        variables.countAll = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(resourceId)+String(count)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserResource);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserResource'); });
        function onCompleteAddUserResource(e:Event):void { completeAddUserResource(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserResource error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserResource(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserResource: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserResource: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserResource OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserResource: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserResource: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserBuilding(wObject:WorldObject, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserBuilding', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = wObject.dataBuild.id;
        variables.posX = wObject.posX;
        variables.posY = wObject.posY;
        if (wObject is Fabrica) {
            variables.countCell = wObject.dataBuild.countCell;
        } else {
            variables.countCell = 0;
        }
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.buildingId)+String(variables.posX)+String(variables.posY)+String(variables.countCell)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserBuilding'); });
        function onCompleteAddUserBuilding(e:Event):void { completeAddUserBuilding(e.target.data, wObject, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserBuilding(response:String, wObject:WorldObject, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserBuilding: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserBuilding OK', 5);
            wObject.dbBuildingId = int(d.message);
            if (g.user.userBuildingData[wObject.dataBuild.id])
                (g.user.userBuildingData[wObject.dataBuild.id] as Object).dbId = int(d.message);
            if (callback != null) {
                callback.apply(null, [true, wObject]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserBuilding: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserBuilding(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserBuilding', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserBuilding'); });
        function onCompleteGetUserBuilding(e:Event):void { completeGetUserBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserBuilding(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        var dbId:int;
        var dataBuild:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserBuilding: wrong JSON:' + String(response));
            return;
        }
        if (d.id == 0) {
            Cc.ch('server', 'getUserBuilding OK', 5);
            g.user.userDataCity.objects = new Array();
            for (var i:int = 0; i < d.message.length; i++) {
                d.message[i].id ? dbId = int(d.message[i].id) : dbId = 0;
                if (!g.allData.getBuildingById(int(d.message[i].building_id))) {
                    Cc.error('no in g.dataBuilding.objectBuilding such id: ' + int(d.message[i].building_id));
                    continue;
                }
//                dataBuild = Utils.objectDeepCopy(g.dataBuilding.objectBuilding[int(d.message[i].building_id)]);
                dataBuild = Utils.objectFromStructureBuildToObject(g.allData.getBuildingById(int(d.message[i].building_id)));
                if (int(d.message[i].in_inventory)) {
                    g.userInventory.addToDecorInventory(dataBuild.id, dbId);
                } else {
                    if (d.message[i].time_build_building) {
                        ob = {};
                        ob.dbId = dbId;
                        ob.timeBuildBuilding = Number(d.message[i].time_build_building);
                        ob.isOpen = int(d.message[i].is_open);
                        g.user.userBuildingData[int(d.message[i].building_id)] = ob;
                    }
                    dataBuild.dbId = dbId;
                    dataBuild.isFlip = int(d.message[i].is_flip);
                    if (d.message[i].count_cell) dataBuild.countCell = int(d.message[i].count_cell);
                    var p:Point = new Point(int(d.message[i].pos_x), int(d.message[i].pos_y));
                    if (dataBuild.buildType == BuildType.CAVE || dataBuild.buildType == BuildType.MARKET ||
                            dataBuild.buildType == BuildType.PAPER || dataBuild.buildType == BuildType.DAILY_BONUS || dataBuild.buildType == BuildType.TRAIN ||  dataBuild.buildType == BuildType.CHEST
                            || dataBuild.buildType == BuildType.CAT_HOUSE || dataBuild.buildType == BuildType.ACHIEVEMENT || dataBuild.buildType == BuildType.MISSING) {
                        //do nothing, use usual x and y from server
//                        p.x *= g.scaleFactor;
//                        p.y *= g.scaleFactor;  // scaleFactor will use at pasteBuild
                    } else {
                        // in another case we get isometric coordinates from server
                        p = g.matrixGrid.getXYFromIndex(p);
                    }

                    ob = {};
                    ob.buildId = dataBuild.id;
                    ob.posX = int(d.message[i].pos_x);
                    ob.posY = int(d.message[i].pos_y);
                    ob.isFlip = int(d.message[i].is_flip);
                    ob.dbId = dbId;
                    if (d.message[i].time_build_building) {
                        ob.isBuilded = true;
                        ob.isOpen = Boolean(int(d.message[i].is_open));
                    }
                    g.user.userDataCity.objects.push(ob);
                    var build:WorldObject = g.townArea.createNewBuild(dataBuild, dbId);
                    if (build is DecorTail) {
                        g.townArea.pasteTailBuild(build as DecorTail, p.x, p.y, false);
                    } else {
                        g.townArea.pasteBuild(build, p.x, p.y, false);
                    }
                }
            }
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserBuilding: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function startBuildBuilding(wObject:WorldObject, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_START_BUILD_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'startBuildMapBuilding', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = wObject.dataBuild.id;
        variables.dbId = wObject.dbBuildingId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.buildingId)+String(variables.dbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteStartBuildMapBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('startBuildMapBuilding'); });
        function onCompleteStartBuildMapBuilding(e:Event):void { completeStartBuildMapBuilding(e.target.data, wObject, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('startBuildMapBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeStartBuildMapBuilding(response:String, wObject:WorldObject, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('startBuildMapBuilding: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'startBuildMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'startBuildMapBuilding OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('startBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'startBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function openBuildedBuilding(wObject:WorldObject, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_OPEN_BUILDED_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'openBuildMapBuilding', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = wObject.dataBuild.id;
        variables.dbId = wObject.dbBuildingId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.buildingId)+String(variables.dbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteOpenBuildMapBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('openBuildedBuilding'); });
        function onCompleteOpenBuildMapBuilding(e:Event):void { completeOpenBuildMapBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('openBuildMapBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeOpenBuildMapBuilding(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('openBuildMapBuilding: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'openBuildMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'openBuildMapBuilding OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('openBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'openBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addFabricaRecipe(recipeId:int, dbId:int, delay:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addFabricaRecipe', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.recipeId = recipeId;
        variables.dbId = dbId;
        variables.delay = delay;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+String(recipeId)+String(delay)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddFabricaRecipe);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addFabricaRecipe'); });
        function onCompleteAddFabricaRecipe(e:Event):void { completeAddFabricaRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addFabricaRecipe error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddFabricaRecipe(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addFabricaRecipe: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addFabricaRecipe: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addFabricaRecipe OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addFabricaRecipe: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserFabricaRecipe(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserFabricaRecipe', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserFabricaRecipe);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUerFabricaRecipe'); });
        function onCompleteGetUserFabricaRecipe(e:Event):void { completeGetUserFabricaRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserFabricaRecipe error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserFabricaRecipe(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserFabricaRecipe: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserFabricaRecipe OK', 5);
            (d.message as Array).sortOn('delay', Array.NUMERIC);
            g.managerFabricaRecipe = new ManagerFabricaRecipe();
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerFabricaRecipe.addRecipeFromServer(d.message[i]);
            }
            g.managerFabricaRecipe.onLoadFromServer();
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserFabricaRecipe: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftFabricaRecipe(dbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftFabricaRecipe', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftFabricaRecipe);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('craftFabricaRecipe'); });
        function onCompleteCraftFabricaRecipe(e:Event):void { completeCraftFabricaRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftFabricaRecipe error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeCraftFabricaRecipe(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftFabricaRecipe: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftFabricaRecipe: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'craftFabricaRecipe OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('craftFabricaRecipe: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function rawPlantOnRidge(plantId:int, dbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RAW_PLANT_RIDGE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'rawPlantOnRidge', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.plantId = plantId;
        variables.dbId = dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(plantId)+String(dbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRawPlantOnRidge);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('rawPlantOnRidge'); });
        function onCompleteRawPlantOnRidge(e:Event):void { completeRawPlantOnRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('rawPlantOnRidge error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeRawPlantOnRidge(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('rawPlantOnRidge: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'rawPlantOnRidge: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'rawPlantOnRidge OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('rawPlantOnRidge: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'rawPlantOnRidge: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserPlantRidge(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_PLANT_RIDGE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserPlantRidge', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserPlantRidge);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserPlantRidge'); });
        function onCompleteGetUserPlantRidge(e:Event):void { completeGetUserPlantRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserPlantRidge error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserPlantRidge(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserPlantRidge: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserPlantRidge: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserPlantRidge OK', 5);
            var ob:Object;
            var time:int;
            var timeWork:int;

            g.user.userDataCity.plants = [];
            g.managerPlantRidge = new ManagerPlantRidge();
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerPlantRidge.addPlant(d.message[i]);

                ob = {};
                ob.plantId = int(d.message[i].plant_id);
                ob.dbId = int(d.message[i].user_db_building_id);
                time = g.allData.getResourceById(ob.plantId).buildTime;
                timeWork = int(d.message[i].time_work);
                if (timeWork > time) ob.state = Ridge.GROWED;
                else if (timeWork > 2/3*time) ob.state = Ridge.GROW3;
                else if (timeWork > time/3) ob.state = Ridge.GROW2;
                else ob.state = Ridge.GROW1;
                if (d.message[i].friend_id) ob.friendId = int(d.message[i].friend_id);
                g.user.userDataCity.plants.push(ob);
            }
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserPlantRidge: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserPlantRidge: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftPlantRidge(dbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_PLANT_RIDGE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftPlantRidge', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftPlantRidge);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('craftPlantRidge'); });
        function onCompleteCraftPlantRidge(e:Event):void { completeCraftPlantRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftPlantRidge error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeCraftPlantRidge(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftPlantRidge: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftPlantRidge: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'craftPlantRidge OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('craftPlantRidge: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftPlantRidge: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserTree(wObject:WorldObject, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = wObject.dbBuildingId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.dbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserTree'); });
        function onCompleteAddUserTree(e:Event):void { completeAddUserTree(e.target.data, wObject, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserTree(response:String, wObject:WorldObject, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserTree: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserTree OK', 5);
            (wObject as Tree).tree_db_id = d.message;
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserTree: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserTree(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserTree'); });
        function onCompleteGetUserTree(e:Event):void { completeGetUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserTree OK', 5);
            var ob:Object;
            g.user.userDataCity.trees = [];
            g.managerTree = new ManagerTree();
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerTree.addTree(d.message[i]);

                ob = {};
                ob.dbId = int(d.message[i].user_db_building_id);
                ob.time_work = int(ob.time_work);
                g.user.userDataCity.trees.push(ob);
            }
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function  updateUserTreeState(treeDbId:String, state:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TREE_STATE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTreeState', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = treeDbId;
        variables.state = state;
        variables.hash = MD5.hash(String(g.user.userId)+String(treeDbId)+String(state)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTreeState);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserTreeState'); });
        function onCompleteUpdateUserTreeState(e:Event):void { completeUpdateUserTreeState(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTreeState error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTreeState(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTreeState: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTreeState: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTreeState OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTreeState: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTreeState: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteUserTree(treeDbId:String, dbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.treeDbId = treeDbId;
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('deleteUserTree'); });
        function onCompleteDeleteUserTree(e:Event):void { completeDeleteUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUserTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteUserTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deleteUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserAnimal(an:Animal, farmDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserAnimal', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.farmDbId = farmDbId;
        variables.animalId = an.animalData.id;
        variables.hash = MD5.hash(String(g.user.userId)+String(farmDbId)+String(variables.animalId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserAnimal'); });
        function onCompleteAddUserAnimal(e:Event):void { completeAddUserAnimal(e.target.data, an, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserAnimal(response:String, an:Animal, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserAnimal: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserAnimal: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserAnimal OK', 5);
            an.animal_db_id = d.message;
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserTree: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function rawUserAnimal(anDbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RAW_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'rawUserAnimal', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.anDbId = anDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(anDbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRawUserAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('rawUserAnimal'); });
        function onCompleteRawUserAnimal(e:Event):void { completeRawUserAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('rawUserAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeRawUserAnimal(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('rawUserAnimal: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'rawUserAnimal: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'rawUserAnimal OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('rawUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'rawUserTree: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserAnimal(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserAnimal', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserAnimal'); });
        function onCompleteGetUserAnimal(e:Event):void { completeGetUserAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserAnimal error:' + error.errorID);
        }
    }

    private function completeGetUserAnimal(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserAnimal: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserAnimal: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserAnimal OK', 5);
            var ob:Object;
            g.user.userDataCity.animals = [];
            g.managerAnimal = new ManagerAnimal();
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerAnimal.addAnimal(d.message[i]);
                ob = {};
                ob.animalId = int(d.message[i].animal_id);
                ob.timeWork = int(d.message[i].time_work);
                ob.dbId = int(d.message[i].user_db_building_id);
                g.user.userDataCity.animals.push(ob);
            }
//            g.managerAnimal.checkPositionAnimals();
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('GetUserAnimal: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function craftUserAnimal(animalDbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftUserAnimal', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.animalDbId = animalDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(animalDbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftUserAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('craftUserAnimal'); });
        function onCompleteCraftUserAnimal(e:Event):void { completeCraftUserAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftUserAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeCraftUserAnimal(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftUserAnimal: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserAnimal: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'craftUserAnimal OK', 5);
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerAnimal.addAnimal(d.message[i]);
            }
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('craftUserAnimal: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserTrain(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_TRAIN);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserTrain', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserTrain);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserTrain'); });
        function onCompleteAddUserTrain(e:Event):void { completeAddUserTrain(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserTrain error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserTrain(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserTrain: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserTrain: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [0]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserTrain OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserTrain: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserTrain: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [0]);
            }
        }
    }

    public function getUserTrain(callback:Function):void {
        var tr:Train = g.townArea.getCityObjectsByType(BuildType.TRAIN)[0];
        if (tr == null || tr.dataBuild == null) {
            if (callback != null) {
                callback.apply();
            }
            return;
        }
        if (g.user.level < tr.dataBuild.blockByLevel[0]) {
            Cc.ch('server', 'getUserTrain:: g.user.level < ' + String(tr.dataBuild.blockByLevel[0]), 1);
            tr.fillItDefault();
            if (callback != null) {
                callback.apply();
            }
            return;
        }
        if (tr.stateBuild < 4) {
            Cc.ch('server', 'getUserTrain:: train.stateBuild < 4', 1);
            tr.fillItDefault();
            if (callback != null) {
                callback.apply();
            }
            return;
        }
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_TRAIN);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserTrain', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserTrain);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserTrain'); });
        function onCompleteGetUserTrain(e:Event):void { completeGetUserTrain(e.target.data, tr, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserTrain error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserTrain(response:String, tr:Train, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserTrain: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserTrain: wrong JSON:' + String(response));
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserTrain OK', 5);
            tr.fillFromServer(d.message);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('GetUserTrain: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserTrain: id: ' + d.id + '  with message: ' + d.message);
        }

        if (callback != null) {
            callback.apply();
        }
    }

    public function updateUserTrainState(state:int, train_db_id:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TRAIN_STATE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTrainState', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.state = state;
        variables.id = train_db_id;
        variables.hash = MD5.hash(String(g.user.userId)+String(train_db_id)+String(state)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTrainState);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserTrainState'); });
        function onCompleteUpdateUserTrainState(e:Event):void { completeUpdateUserTrainState(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTrainState error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTrainState(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTrainState: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainState: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTrainState OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTrainState: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainState: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function getTrainPack(userSocialId:String, callback:Function, t:Train = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_TRAIN_PACK_NEW);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getTrainPack', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.userSocialId = userSocialId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetTrainPack);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getTrainPack'); });
        function onCompleteGetTrainPack(e:Event):void { completeGetTrainPack(t, e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getTrainPack error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetTrainPack(t:Train = null, response:String = '', callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getTrainPack: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getTrainPack: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getTrainPack OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message,t]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getTrainPack: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getTrainPack: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function releaseUserTrainPack(train_db_id:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RELEASE_USER_TRAIN_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'releaseUserTrainPack', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = train_db_id;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.id)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteReleaseUserTrainPack);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('releaseUserTrainPack'); });
        function onCompleteReleaseUserTrainPack(e:Event):void { completeReleaseUserTrainPack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('releaseUserTrainPack error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeReleaseUserTrainPack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('releaseUserTrainPack: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'releaseUserTrainPack: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'releaseUserTrainPack OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('releaseUserTrainPack: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'releaseUserTrainPack: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function updateUserTrainPackItems(train_item_db_id:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TRAIN_PACK_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTrainPackItems ', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = train_item_db_id;
        variables.hash = MD5.hash(String(g.user.userId)+String(train_item_db_id)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTrainPackItems);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserTrainPackItem'); });
        function onCompleteUpdateUserTrainPackItems(e:Event):void { completeUpdateUserTrainPackItems(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTrainPackItems error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTrainPackItems(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTrainPackItems: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainPackItems: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTrainPackItems OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTrainPackItems: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainPackItems: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function deleteUser(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUser', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUser);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('deleteUser'); });
        function onCompleteDeleteUser(e:Event):void { completeDeleteUser(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUser error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUser(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        if (callback != null) {
            callback.apply();
        }
        Cc.error('deleteUser responce:' + response);
    }

    public function addUserMarketItem(id:int, levelResource:int, count:int, inPapper:Boolean, cost:int, numberCell:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_MARKET_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserMarketItem', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.resourceId = id;
        variables.level = levelResource;
        variables.count = count;
        variables.cost = cost;
        variables.numberCell = numberCell;
        variables.inPapper = int(inPapper);
        variables.timeInPapper = 0;
        variables.hash = MD5.hash(String(g.user.userId)+String(id)+String(count)+String(cost)+String(numberCell)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserMarketItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserMarketItem'); });
        function onCompleteAddUserMarketItem(e:Event):void { completeAddUserMarketItem(e.target.data, id, count, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserMarketItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserMarketItem(response:String, id:int, count:int, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserMarketItem: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserMarketItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserMarketItem OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message, id, count]);
            }
        } else if (d.id == 13) {
            Cc.ch('server', 'addUserMarketItem anotherGame', 5);
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            Cc.ch('server', 'addUserMarketItem SERVER CRACK', 5);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserMarketItem: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserMarketItem(socialId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_MARKET_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserMarketItem', 1);
        variables = addDefault(variables);
        variables.userSocialId = socialId;
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserMarketItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserMarketItem'); });
        function onCompleteGetUserMarketItem(e:Event):void { completeGetUserMarketItem(e.target.data, socialId, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserMarketItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserMarketItem(response:String, socialId:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserMarketItem: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserMarketItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserMarketItem OK', 5);
            if (socialId == g.user.userSocialId) g.user.fillUserMarketItems(d.message.items, int(d.message.market_cell));
            else g.user.fillSomeoneMarketItems(d.message.items, socialId, int(d.message.market_cell));
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 14 && !g.tuts.isTuts) {
            Cc.error('getUserMarketItem d.id=14 :: unknown socialId: ' + socialId);
            g.windowsManager.closeAllWindows();
        } else {
            Cc.error('getUserMarketItem: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function buyFromMarket(item:StructureMarketItem, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_BUY_FROM_MARKET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyFromMarket', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.itemId = item.id;
        variables.shardName = item.shardName;
        variables.hash = MD5.hash(String(g.user.userId)+String(item.id)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuyFromMarket);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('buyFromMarket'); });
        function onCompleteBuyFromMarket(e:Event):void { completeBuyFromMarket(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyFromMarket error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuyFromMarket(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyFromMarket: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyFromMarket: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'buyFromMarket OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('buyFromMarket: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyFromMarket: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteUserMarketItem(itemId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_MARKET_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserMarketItem', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.itemId = itemId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserMarketItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('deleteUserMarketItem'); });
        function onCompleteDeleteUserMarketItem(e:Event):void { completeDeleteUserMarketItem(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserMarketItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUserMarketItem(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserMarketItem: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserMarketItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteUserMarketItem OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deleteUserMarketItem: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserBuildPosition(dbId:int, pX:int, pY:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_BUILD_POSITION);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserBuildPosition', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.posX = pX;
        variables.posY = pY;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+String(pX)+String(pY)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserBuildPosition);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserBuildPosition'); });
        function onCompleteUpdateUserBuildPosition(e:Event):void { completeUpdateUserBuildPosition(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserBuildPosition error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserBuildPosition(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserBuildPosition: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserBuildPosition: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserBuildPosition OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserBuildPosition: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserBuildPosition: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getPaperItems(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_PAPER_ITEMS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getPaperItems', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.level = g.user.level;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetPaperItems);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getPaperItems'); });
        function onCompleteGetPaperItems(e:Event):void { completeGetPaperItems(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getPaperItems error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetPaperItems(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getPaperItems: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getPaperItems: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getPaperItems OK', 5);
            g.managerPaper.fillIt(d.message);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getPaperItems: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getPaperItems: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserAmbar(isAmbar:int, newLevel:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_AMBAR);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserAmbar', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.isAmbar = isAmbar;
        variables.newLevel = newLevel;
        variables.hash = MD5.hash(String(g.user.userId)+String(newLevel)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserAmbar);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserAmbar'); });
        function onCompleteUpdateUserAmbar(e:Event):void { completeUpdateUserAmbar(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserAmbar error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserAmbar(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserAmbar: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAmbar: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserAmbar OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserAmbar: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAmbar: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataLockedLand(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_LOCKED_LAND);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        Cc.ch('server', 'start getDataLockedLand', 1);
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataLockedLand);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataLockedLand'); });
        function onCompleteGetDataLockedLand(e:Event):void { completeGetDataLockedLand(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataLockedLand error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetDataLockedLand(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataLockedLand: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataLockedLand: wrong JSON:' + String(response));
            return;
        }

        g.allData.lockedLandData = {};
        if (d.id == 0) {
            Cc.ch('server', 'getDataLockedLand OK', 5);
            var obj:Object;
            for (var i:int = 0; i < d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].map_building_id);
                obj.blockByLevel = int(d.message[i].block_by_level);
                obj.resourceId = int(d.message[i].resource_id);
                obj.resourceCount = int(d.message[i].resource_count);
                obj.friendsCount = int(d.message[i].friends_count);
                obj.currencyCount = int(d.message[i].currency_count);
                g.allData.lockedLandData[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataLockedLand: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataLockedLand: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function removeUserLockedLand(id:int, callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_REMOVE_USER_LOCKED_LAND);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.mapBuildingId = id;
        variables.hash = MD5.hash(String(g.user.userId)+String(id)+SECRET);
        request.data = variables;
        Cc.ch('server', 'start removeUserLockedLand', 1);
        Cc.ch('info', 'remove lockedLand id: ' + id);
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteRemoveUserLockedLand);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('removeUserLockedLand'); });
        function onCompleteRemoveUserLockedLand(e:Event):void { completeRemoveUserLockedLand(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('removeUserLockedLand error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeRemoveUserLockedLand(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('removeUserLockedLand: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'removeUserLockedLand: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'removeUserLockedLand OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('removeUserLockedLand: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'removeUserLockedLand: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addToInventory(dbId:int, callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_TO_INVENTORY);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+SECRET);
        request.data = variables;
        Cc.ch('server', 'start addToInventory', 1);
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddToInventory);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addToInventory'); });
        function onCompleteAddToInventory(e:Event):void { completeAddToInventory(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addToInventory error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddToInventory(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addToInventory: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addToInventory: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addToInventory',5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addToInventory: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addToInventory: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function removeFromInventory(dbId:int, posX:int, posY:int, callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_REMOVE_FROM_INVENTORY);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.posX = posX;
        variables.posY = posY;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+SECRET);
        request.data = variables;
        Cc.ch('server', 'start removeFromInventory', 1);
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteRemoveFromInventory);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('removeFromInventory'); });
        function onCompleteRemoveFromInventory(e:Event):void { completeRemoveFromInventory(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('removeFromInventory error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeRemoveFromInventory(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('removeFromInventory: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'removeFromInventory: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'removeFromInventory OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('removeFromInventory: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'removeFromInventory: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserNeighborMarket(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_NEIGHBOR_MARKET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserNeighborMarket', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserNeighborMarket);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserNeighborMarket'); });
        function onCompleteGetUserNeighborMarket(e:Event):void { completeGetUserNeighborMarket(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserNeighborMarketItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserNeighborMarket(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserNeighborMarket: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserNeighborMarket: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserNeighborMarket OK', 5);
            g.user.fillNeighborMarketItems(d.message);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserNeighborMarket: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserNeighborMarket: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function buyFromNeighborMarket(itemId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_BUY_FROM_NEIGHBOR_MARKET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyFromNeighborMarket', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.itemId = itemId;
        variables.hash = MD5.hash(String(g.user.userId)+String(itemId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuyFromNeighborMarket);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('buyFromNieghborMarket'); });
        function onCompleteBuyFromNeighborMarket(e:Event):void { completeBuyFromNeighborMarket(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyFromNeighborMarket error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuyFromNeighborMarket(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyFromNeighborMarket: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyFromNeighborMarket: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'buyFromNeighborMarket OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('buyFromNeighborMarket: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyFromNeighborMarket: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getAllCityData(p:Someone, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_ALL_CITY_DATA);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getAllCityData', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.userSocialId = p.userSocialId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.userSocialId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetAllCityData);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getAllCityData'); });
        function onCompleteGetAllCityData(e:Event):void { completeGetAllCityData(e.target.data, p, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getAllCityData error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetAllCityData(response:String, p:Someone, callback:Function):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getAllCityData: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllCityData: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var k:int;
            Cc.ch('server', 'getAllCityData OK', 5);
            p.userDataCity.objects = new Array();
            for (var i:int = 0; i < d.message['building'].length; i++) {
                ob = {};
                k = int(d.message['building'][i].building_id);
                if (!g.allData.getBuildingById(k)) {
                    Cc.error(' completeGetAllCityData:: no in g.dataBuilding.objectBuilding for building with building_id: ' + k);
                    continue;
                }
                ob.buildId = g.allData.getBuildingById(k).id;
                ob.posX = int(d.message['building'][i].pos_x);
                ob.posY = int(d.message['building'][i].pos_y);
                ob.dbId = int(d.message['building'][i].id);
                ob.isFlip = int(d.message['building'][i].is_flip);
                if (d.message['building'][i].time_build_building) {
                    ob.isBuilded = true;
                    ob.isOpen = Boolean(int(d.message['building'][i].is_open));
                }
                if (d.message['building'][i].train_state) {
                    ob.state = int(d.message['building'][i].train_state);
                }
                p.userDataCity.objects.push(ob);
            }
            p.userDataCity.plants = new Array();
            for (i = 0; i < d.message['plant'].length; i++) {
                ob = {};
                ob.plantId = int(d.message['plant'][i].plant_id);
                ob.dbId = int(d.message['plant'][i].user_db_building_id);
                ob.timeWork = int(d.message['plant'][i].time_work);
                ob.friendId = String(d.message['plant'][i].friend_id);
                p.userDataCity.plants.push(ob);
            }
            p.userDataCity.trees = new Array();
            for (i=0; i<d.message['tree'].length; i++) {
                ob = {};
                ob.id = d.message['tree'][i].id;
                ob.dbId = int(d.message['tree'][i].user_db_building_id);
                ob.state = int(d.message['tree'][i].state);
                ob.time_work = int(d.message['tree'][i].time_work);
                p.userDataCity.trees.push(ob);
            }
            p.userDataCity.animals = new Array();
            for (i=0; i<d.message['animal'].length; i++) {
                ob = {};
                ob.animalId = int(d.message['animal'][i].animal_id);
                if (int(d.message['animal'][i].time_work) > 0) {
                    ob.time_work = TimeUtils.currentSeconds - int(d.message['animal'][i].time_work);
                } else ob.time_work = int(d.message['animal'][i].time_work);
                ob.dbId = int(d.message['animal'][i].user_db_building_id);
                p.userDataCity.animals.push(ob);
            }
            p.userDataCity.pets = new Array();
            for (i=0; i<d.message['pet'].length; i++) {
                ob = {};
                ob.petId = int(d.message['pet'][i].pet_id);
                ob.houseDbId = int(d.message['pet'][i].house_db_id);
                p.userDataCity.pets.push(ob);
            }
            p.userDataCity.recipes = new Array();
            for (i=0; i<d.message['recipe'].length; i++) {
                ob = {};
                ob.recipeId = int(d.message['recipe'][i].recipe_id);
                ob.timeWork = int(d.message['recipe'][i].time_work);
                ob.delay = int(d.message['recipe'][i].delay);
                ob.dbId = int(d.message['recipe'][i].user_db_building_id);
                p.userDataCity.recipes.push(ob);
            }
            for (i = 0; i < d.message['wild'].length; i++) {
                ob = {};
                k = int(d.message['wild'][i].building_id);
                if (!g.allData.getBuildingById(k)) {
                    Cc.error(' completeGetAllCityData:: no in g.dataBuilding.objectBuilding for wild with building_id: ' + k);
                    continue;
                }
                ob.buildId = k;
                ob.posX = int(d.message['wild'][i].pos_x);
                ob.posY = int(d.message['wild'][i].pos_y);
                ob.dbId = int(d.message['wild'][i].id);
                ob.isFlip = int(d.message['wild'][i].is_flip);
                if (d.message['wild'][i].chest_id) {
                    ob.chestId = int(d.message['wild'][i].chest_id);
                }
                p.userDataCity.objects.push(ob);
            }
            if (callback != null) {
                callback.apply(null, [p]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getAllCityData: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllCityData: id: ' + d.id + '  with message: ' + d.message);
        }
    }

      public function ME_addWild(posX:int, posY:int, w:WorldObject, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_ADD_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_addWild', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.posX = posX;
        variables.posY = posY;
        variables.wildId = w.dataBuild.id;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_addWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('ME_addWild'); });
        function onCompleteME_addWild(e:Event):void { completeME_addWild(e.target.data, w, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_addWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_addWild(response:String, w:WorldObject, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_addWild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_addWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_addWild OK', 5);
            w.dbBuildingId = int(d.message);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_addWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_addWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_removeWild(dbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_REMOVE_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_removeWild', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_removeWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('ME_removeWild'); });
        function onCompleteME_removeWild(e:Event):void { completeME_removeWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_removeWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_removeWild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_removeWild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_removeWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_removeWild OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_removeWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_removeWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_moveWild(posX:int, posY:int, dbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_MOVE_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_moveWild', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.posX = posX;
        variables.posY = posY;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_moveWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('ME_moveWild'); });
        function onCompleteME_moveWild(e:Event):void { completeME_moveWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_moveWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_moveWild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_moveWild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_moveWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_moveWild OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_moveWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_moveWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_flipWild(dbId:int, isFlip:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_FLIP_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_flipWild', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.isFlip = isFlip;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_flipWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('ME_flipWild'); });
        function onCompleteME_flipWild(e:Event):void { completeME_flipWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_flipWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_flipWild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_flipWild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_flipWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_flipWild OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_flipWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_flipWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function getUserWild(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserWild', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserWild'); });
        function onCompleteGetUserWild(e:Event):void { completeGetUserWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserWild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        var dbId:int;
        var dataBuild:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserWild: wrong JSON:' + String(response));
            return;
        }
        if (d.id == 0) {
            Cc.ch('server', 'getUserWild OK', 5);
            for (var i:int = 0; i < d.message.length; i++) {
                d.message[i].id ? dbId = int(d.message[i].id) : dbId = 0;
                dataBuild = Utils.objectFromStructureBuildToObject(g.allData.getBuildingById(int(d.message[i].building_id)));
                var p:Point = g.matrixGrid.getXYFromIndex(new Point(int(d.message[i].pos_x), int(d.message[i].pos_y)));
                if (dataBuild) {
                    dataBuild.dbId = dbId;
                    dataBuild.isFlip = int(d.message[i].is_flip);
                    dataBuild.chestId = int(d.message[i].chest_id);

                    ob = {};
                    ob.buildId = dataBuild.id;
                    ob.posX = int(d.message[i].pos_x);
                    ob.posY = int(d.message[i].pos_y);
                    ob.isFlip = int(d.message[i].is_flip);
                    ob.dbId = dbId;
                    ob.chestId = int(d.message[i].chest_id);
                    g.user.userDataCity.objects.push(ob);
                    var build:WorldObject = g.townArea.createNewBuild(dataBuild, dbId);
                    g.townArea.pasteBuild(build, p.x, p.y, false);
                }
            }
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            Cc.error('GetUserWild: another game');
        } else {
            Cc.error('GetUserWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserWild: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function userBuildingFlip(dbId:int, isFlip:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_BUILDING_FLIP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'userBuildingFlip', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.isFlip = isFlip;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUserBuildingFlip);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('userBuildingFlip'); });
        function onCompleteUserBuildingFlip(e:Event):void { completeUserBuildingFlip(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('userBuildingFlip error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUserBuildingFlip(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('userBuildingFlip: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'userBuildingFlip OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('userBuildingFlip: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function deleteUserWild(dbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserWild', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('deleteUserWild'); });
        function onCompleteDeleteUserWild(e:Event):void { completeDeleteUserWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUserWild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserWildp: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteUserWild OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deleteUserWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_moveMapBuilding(id:int, posX:int, posY:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_MOVE_MAP_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_moveMapBuilding', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.buildId = id;
        variables.posX = posX;
        variables.posY = posY;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_moveMapBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('ME_moveMapBuilding'); });
        function onCompleteME_moveMapBuilding(e:Event):void { completeME_moveMapBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_moveMapBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_moveMapBuilding(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_moveMapBuilding: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_moveMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_moveMapBuilding OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_moveMapBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_moveMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function saveUserGameScale(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_GAME_SCALE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'saveUserGameScale', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.scale = g.currentGameScale*100;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.scale)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSaveUserGameScale);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('saveUserGameScale'); });
        function onCompleteSaveUserGameScale(e:Event):void { completeSaveUserGameScale(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('saveUserGameScale error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSaveUserGameScale(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('saveUserGameScale: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'saveUserGameScale: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'saveUserGameScale OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('saveUserGameScale: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'saveUserGameScale: wrong JSON:' + String(response));
        }
    }

    public function buyNewCellOnFabrica(dbId:int, count:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_CELL_FABRICA);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyNewCellOnFabrica', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.count = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+String(count)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuyNewCellOnFabrica);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('buyNewCellOnFabrica'); });
        function onCompleteBuyNewCellOnFabrica(e:Event):void { completeBuyNewCellOnFabrica(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyNewCellOnFabrica error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuyNewCellOnFabrica(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyNewCellOnFabrica: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyNewCellOnFabrica: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'buyNewCellOnFabrica OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('buyNewCellOnFabrica: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyNewCellOnFabrica: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipRecipeOnFabrica(userRecipeDbId:String, leftTime:int, buildDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_RECIPE_FABRICA);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'skipRecipeOnFabrica', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.recipeDbId = userRecipeDbId;
        variables.leftTime = leftTime;
        variables.buildDbId = buildDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(userRecipeDbId)+String(leftTime)+String(buildDbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipRecipeOnFabrica);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('skipRecipeFabrica'); });
        function onCompleteSkipRecipeOnFabrica(e:Event):void { completeSkipRecipeOnFabrica(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipRecipeOnFabrica error:' + error.errorID);
//          g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipRecipeOnFabrica(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipRecipeOnFabrica: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipRecipeOnFabrica: wrong JSON:' + String(response));
            return;
        }
        if (d.warning != '') {
            Cc.error('DirectServer completeSkipRecipeOnFabrica:: warning: ' + d.warning);
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipRecipeOnFabrica OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipRecipeOnFabrica: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipRecipeOnFabrica: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteRecipeOnFabrica(idFromServer:String, leftTime:int, buildDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_RECIPE_FABRICA);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteRecipeOnFabrica', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = idFromServer;
        variables.leftTime = leftTime;
        variables.buildDbId = buildDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(idFromServer)+String(leftTime)+String(buildDbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteRecipeOnFabrica);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('deleteRecipeOnFabrica'); });
        function onCompleteDeleteRecipeOnFabrica(e:Event):void { completeDeleteRecipeOnFabrica(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteRecipeOnFabrica error:' + error.errorID);
//          g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteRecipeOnFabrica(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteRecipeOnFabrica: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteRecipeOnFabrica: wrong JSON:' + String(response));
            return;
        }
        if (d.warning != '') {
            Cc.error('DirectServer completeDeleteRecipeOnFabrica:: warning: ' + d.warning);
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteRecipeOnFabrica OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('deleteRecipeOnFabrica: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteRecipeOnFabrica: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnRidge(plantTime:int,buildDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_RIDGE);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();

        Cc.ch('server', 'skipTimeOnRidge', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.plantTime = time - plantTime;
        variables.buildDbId = buildDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.plantTime)+String(buildDbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteskipTimeOnRidge);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('skipTimeOnRidge'); });
        function onCompleteskipTimeOnRidge(e:Event):void { completeskipTimeOnRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnRidge error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeskipTimeOnRidge(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnRidge: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnRidge: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipTimeOnRidge OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('skipTimeOnRidge: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnRidge: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnTree(stateTree:int, buildDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'skipTimeOnTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.state = stateTree;
        variables.id = buildDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(stateTree)+String(buildDbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipTimeOnTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('skipTimeOnTree'); });
        function onCompleteSkipTimeOnTree(e:Event):void { completeSkipTimeOnTree(e.target.data,callback);}//e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipTimeOnTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipTimeOnTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipTimeOnTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnAnimal(timeToEnd:int,buildDbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_ANIMAL);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();
        Cc.ch('server', 'skipTimeOnAnimal', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.animalDbId = int(buildDbId);
        variables.timeToEnd = time - timeToEnd;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.animalDbId)+String(variables.timeToEnd)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteskipTimeOnAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('skipTimeOnAnimal'); });
        function onCompleteskipTimeOnAnimal(e:Event):void { completeskipTimeOnAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);

        }
    }

    private function completeskipTimeOnAnimal(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnAnimal: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnAnimal: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipTimeOnAnimal OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipTimeOnAnimal: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnFabricBuild(leftTime:int, buildDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_FABRIC_BUILD);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();

        Cc.ch('server', 'skipTimeOnFabricBuild', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.leftTime = time - leftTime;
        variables.buildDbId = buildDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.leftTime)+String(buildDbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipTimeOnFabricBuild);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('skipTimeOnFabricBuild'); });
        function onCompleteSkipTimeOnFabricBuild(e:Event):void { completeSkipTimeOnFabricBuild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnFabricBuild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipTimeOnFabricBuild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnFabricBuild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnFabricBuild: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipTimeOnFabricBuild OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipTimeOnFabricBuild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnFabricBuild: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnTrainBuild(leftTime:int, buildId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_TRAIN_BUILD);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();

        Cc.ch('server', 'skipTimeOnTrainBuild', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.leftTime = time - leftTime;
        variables.buildId = buildId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.leftTime)+String(buildId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipTimeOnTrainBuild);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('skipTimeOnTrainBuild'); });
        function onCompleteSkipTimeOnTrainBuild(e:Event):void { completeSkipTimeOnTrainBuild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnTrainBuild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipTimeOnTrainBuild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnTrainBuild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnTrainBuild: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipTimeOnTrainBuild OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipTimeOnTrainBuild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnFabricBuild: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserOrder(order:Object, delay:int, catId:int, txtId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_ORDER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.catId = catId;
        variables.txtId = txtId;
        variables.ids = order.resourceIds.join('&');
        variables.counts = order.resourceCounts.join('&');
        variables.xp = order.xp;
        variables.coins = order.coins;
        if (variables.xp == 0) { // kostul_1 for error
            variables.xp = 25;
            variables.ids = '31';
            variables.counts = '10';
            variables.coins = 25;
        }
        variables.addCoupone = int(order.addCoupone);
        variables.delay = delay;
        variables.place = order.placeNumber;
        variables.fasterBuyer = order.fasterBuy;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.ids)+String(variables.counts)+String(variables.xp)+String(variables.coins)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserOrder);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserOrder'); });
        function onCompleteAddUserOrder(e:Event):void { completeAddUserOrder(e.target.data, order, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserOrder error:' + error.errorID);
        }
    }

    private function completeAddUserOrder(response:String, order:Object, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserOrder: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserOrder OK', 5);
            order.dbId = String(d.message);
            if (callback != null) {
                callback.apply(null, [order]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserOrder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getUserOrder(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_ORDER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserOrder);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserOrder'); });
        function onCompleteGetUserOrder(e:Event):void { completeGetUserOrder(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserOrder error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserOrder(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserOrder: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserOrder OK', 5);
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerOrder.addFromServer(d.message[i]);
            }
//            g.managerOrder.checkCatId();
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('GetUserFOrder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteUserOrder(orderDbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_ORDER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = orderDbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserOrder);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('deleteUserOrder'); });
        function onCompleteDeleteUserOrder(e:Event):void { completeDeleteUserOrder(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserOrder error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUserOrder(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserOrder: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteUserOrder OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deleteUserOrder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function askWateringUserTree(treeDbId:String, state:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ASK_WATERING_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'askWateringUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = treeDbId;
        variables.state = state;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.id)+String(state)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAskWateringUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('askWateringUserTree'); });
        function onCompleteAskWateringUserTree(e:Event):void { completeAskWateringUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('askWateringUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAskWateringUserTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('askWateringUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'askWateringUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'askWateringUserTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('askWateringUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'askWateringUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function makeWateringUserTree(treeDbId:String, state:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_MAKE_WATERING_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'makeWateringUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.userSocialId = g.user.userSocialId;
        variables.awayUserSocialId = g.visitedUser.userSocialId;
        variables.id = treeDbId;
        variables.state = state;
        variables.hash = MD5.hash(String(g.user.userId)+String(g.user.userSocialId)+String(variables.awayUserSocialId)+String(variables.id)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteMakeWateringUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('makeWateringUserTree'); });
        function onCompleteMakeWateringUserTree(e:Event):void { completeMakeWateringUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('MakeWateringUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeMakeWateringUserTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('makeWateringUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'makeWateringUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'makeWateringUserTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('makeWateringUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'makeWateringUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipOrderTimer(orderID:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_ORDER_TIMER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'skipOrderTimer', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = orderID;
        variables.hash = MD5.hash(String(g.user.userId)+String(orderID)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipOrderTimer);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('skipOrderTimer'); });
        function onCompleteSkipOrderTimer(e:Event):void { completeSkipOrderTimer(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipOrderTimer error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipOrderTimer(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipOrderTimer: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipOrderTimer: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipOrderTimer OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipOrderTimer: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipOrderTimer: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftUserTree(treeDbId:String, state:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = treeDbId;
        variables.state = state;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.id)+String(state)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteCraftUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('craftUserTree'); });
        function onCompleteCraftUserTree(e:Event):void { completeCraftUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeCraftUserTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'craftUserTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('craftUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function useDailyBonus(count:int, callback:Function=null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USE_DAILY_BONUS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'useDailyBonus', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.count = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(count)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUseDailyBonus);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('useDailyBonus'); });
        function onCompleteUseDailyBonus(e:Event):void { completeUseDailyBonus(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('useDailyBonus error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUseDailyBonus(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('useDailyBonus: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'useDailyBonus: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'useDailyBonus OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('useDailyBonus: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'useDailyBonus: id: ' + d.id + '  with message: ' + d.message);
        }
    }


    public function buyAndAddToInventory(id:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_BUY_AND_ADD_TO_INVENTORY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyAndAddToInventory', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = id;
        variables.posX = 0;
        variables.posY = 0;
        variables.hash = MD5.hash(String(g.user.userId)+String(id)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuyAndAddToInventory);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('buyAndAddToInventory'); });
        function onCompleteBuyAndAddToInventory(e:Event):void { completeBuyAndAddToInventory(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyAndAddToInventory error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuyAndAddToInventory(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyAndAddToInventory: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyAndAddToInventory: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'buyAndAddToInventory OK', 5);
            if (callback != null) {
                callback.apply(null, [int(d.message)]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('buyAndAddToInventory: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyAndAddToInventory: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function ME_addOutGameTile(posX:int, posY:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_ADD_OUT_GAME_TILE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_addOutGameTile', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.posX = posX;
        variables.posY = posY;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_addOutGameTile);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('ME_addOutGameTile'); });
        function onCompleteME_addOutGameTile(e:Event):void { completeME_addOutGameTile(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_addOutGameTile error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_addOutGameTile(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_addOutGameTile: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_addOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_addOutGameTile OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('ME_addOutGameTile: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_addOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function ME_deleteOutGameTile(posX:int, posY:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_DELETE_OUT_GAME_TILE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_deleteOutGameTile', 1);
        variables = addDefault(variables);
        variables.channelId = g.socialNetworkID;
        variables.posX = posX;
        variables.posY = posY;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_deleteOutGameTile);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('ME_deleteOutGameTile'); });
        function onCompleteME_deleteOutGameTile(e:Event):void { completeME_deleteOutGameTile(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_deleteOutGameTile error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_deleteOutGameTile(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_deleteOutGameTile: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_deleteOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_deleteOutGameTile OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('ME_deleteOutGameTile: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_deleteOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function getDataOutGameTiles(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_DATA_OUT_GAME_TILES);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getDataOutGameTile', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataOutGameTile);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataOutGameTiles'); });
        function onCompleteGetDataOutGameTile(e:Event):void { completeGetDataOutGameTile(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataOutGameTile error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetDataOutGameTile(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataOutGameTile: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataOutGameTile OK', 5);
            for (var i:int = 0; i < d.message.length; i++) {
                g.townArea.addDeactivatedArea(int(d.message[i].pos_x), int(d.message[i].pos_y), true);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataOutGameTile: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function updateUserMarketCell(cell:int,callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_MARKET_CELL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserMarketCell', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.marketCell = g.user.marketCell + cell;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.marketCell)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserMarketCell);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserMarketCell'); });
        function onCompleteUpdateUserMarketCell(e:Event):void { completeUpdateUserMarketCell(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserMarketCell error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserMarketCell(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserMarketCell: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMarketCell: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserMarketCell OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserMarketCell: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMarketCell: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateMarketPapper(numberCell:int,  inPapper:Boolean, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_MARKET_PAPPER);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateMarketPapper', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.numberCell = numberCell;
        variables.inPapper = int(inPapper);
        variables.hash = MD5.hash(String(g.user.userId)+String(numberCell)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateMarketPapper);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateMarketPapper'); });
        function onCompleteUpdateMarketPapper(e:Event):void { completeupdateMarketPapper(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateMarketPapper error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeupdateMarketPapper(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateMarketPapper: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateMarketPapper: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateMarketPapper OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateMarketPapper: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateMarketPapper: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipUserInPaper(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_USER_IN_PAPER);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'skipUserInPaper', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.inPapper = 0;
        variables.hash = MD5.hash(String(g.user.userId)+'0'+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipUserInPaper);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('skipUserInPaper'); });
        function onCompleteSkipUserInPaper(e:Event):void { completeSkipUserInPaper(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipUserInPaper error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipUserInPaper(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipUserInPaper: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipUserInPaper: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipUserInPaper OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipUserInPaper: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipUserInPaper: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function useChest(count:int, callback:Function=null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USE_CHEST);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'useChest', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.count = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(count)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUseChest);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('useChest'); });
        function onCompleteUseChest(e:Event):void { completeUseChest(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('useChest error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUseChest(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('useChest: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'useChest: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'useChest OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('useChest: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'useChest: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserCutScenesData():void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_CUT_SCENE_DATA);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateUserCutScenesData', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.cutScene = Utils.convert2to16(g.user.cutScenes.join(''));
        Cc.info('OK updateUserCutSceneData variables.cutScene: ' + variables.cutScene);
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.cutScene)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserCutScenesData);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserCutScenesData'); });
        function onCompleteUpdateUserCutScenesData(e:Event):void { completeUpdateUserCutScenesData(e.target.data); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserCutScenesData error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserCutScenesData(response:String):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserCutScenesData: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMiniScene: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserCutScenesData OK', 5);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserCutScenesData: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateUserMiniScenesData():void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_MINI_SCENE_DATA);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateUserMiniScenesData', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            variables.miniScene = g.user.miniScenes.join('&');
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID || g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID ) {
            variables.miniScene = Utils.convert2to16(g.user.miniScenes.join(''));
            Cc.info('OK updateUserMiniSceneData variables.miniScene: ' + variables.miniScene);
        }
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.miniScene)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserMiniScenesData);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserMiniScenesData'); });
        function onCompleteUpdateUserMiniScenesData(e:Event):void { completeUpdateUserMiniScenesData(e.target.data); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserMiniScenesData error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserMiniScenesData(response:String):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserMiniScenesData: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMiniScene: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserMiniScenesData OK', 5);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserMiniScenesData: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateOrderCatMiniScenesData(st:String):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_ORDER_CAT_MINI_SCENE_DATA);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateOrderCatMiniScenesData', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.orderCatScene = st;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.orderCatScene)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateOrderCatMiniScenesData);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateOrderCatMiniScenesData'); });
        function onCompleteUpdateOrderCatMiniScenesData(e:Event):void { completeUpdateOrderCatMiniScenesData(e.target.data); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateOrderCatMiniScenesData error:' + error.errorID);
        }
    }

    private function completeUpdateOrderCatMiniScenesData(response:String):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateOrderCatMiniScenesData: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateOrderCatMiniScene: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateOrderCatMiniScenesData OK', 5);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateOrderCatMiniScenesData: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateUserOrder(id:String, place:int, catId:int,callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_ORDER_ITEM);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = id;
        variables.place = place;
        variables.catId = catId;
        variables.hash = MD5.hash(String(g.user.userId)+String(id)+String(place)+String(catId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserOrder);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserOrder'); });
        function onCompleteUpdateUserOrder(e:Event):void { completeUpdateUserOrder(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserOrder error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserOrder(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserOrder: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserOrder OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('updateUserOrder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserPapperBuy(buyerId:int,resourceId:int,resourceCount:int,xp:int,cost:int,visible:int):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_PAPPER_BUY);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'addUserPapperBuy', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buyerId = buyerId;
        variables.resourceId = resourceId;
        variables.resourceCount = resourceCount;
        variables.xp = xp;
        variables.cost = cost;
        variables.visible = visible;
        variables.hash = MD5.hash(String(g.user.userId)+String(buyerId)+String(resourceId)+String(resourceCount)+String(xp)+String(cost)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserPapperBuy);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserPaperBuy'); });
        function onCompleteAddUserPapperBuy(e:Event):void { completeAddUserPapperBuy(e.target.data); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserPapperBuy error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserPapperBuy(response:String):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserPapperBuy: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserPapperBuy: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserPapperBuy OK', 5);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserPapperBuy: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserPapperBuy: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserPapperBuy(buyerId:int,resourceId:int,resourceCount:int,xp:int,cost:int,visible:int, type:int):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_PAPPER_BUY);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateUserPapperBuy', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buyerId = buyerId;
        variables.resourceId = resourceId;
        variables.resourceCount = resourceCount;
        variables.xp = xp;
        variables.cost = cost;
        variables.visible = visible;
        variables.typeResource = type;
        variables.hash = MD5.hash(String(g.user.userId)+String(buyerId)+String(resourceId)+String(resourceCount)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserPapperBuy);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserPaperBuy'); });
        function onCompleteUpdateUserPapperBuy(e:Event):void { completeUpdateUserPapperBuy(e.target.data); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserPapperBuy error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserPapperBuy(response:String):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserPapperBuy: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserPapperBuy: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserPapperBuy OK', 5);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserPapperBuy: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserPapperBuy: id: ' + d.id + '  with message: ' + d.message);
        }
    }


    public function updateDailyGift(count:int):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_DAILY_GIFT);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateDailyGift', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.countDailyGift = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(count)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDailyGift);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateDailyGift'); });
        function onCompleteDailyGift(e:Event):void { completeDailyGift(e.target.data); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateDailyGift error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDailyGift(response:String):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateDailyGift: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateDailyGift: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateDailyGift OK', 5);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateDailyGift: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserPapperBuy: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserPapperBuy(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_PAPPER_BUY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserPapperBuy', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserPapperBuy);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserPapperBuy'); });
        function onCompleteGetUserPapperBuy(e:Event):void { completeGetUserPapperBuy(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserPapperBuy error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserPapperBuy(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserPapperBuy: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserPapperBuy: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserPapperBuy OK', 5);
            g.managerBuyerNyashuk.fillBot(d.message);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserPapperBuy: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserPapperBuy: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserNotification(notif:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_NOTIFICATION);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserNotification', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.notificationNew = notif;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.notificationNew)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserNotification);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserNotification'); });
        function onCompleteUpdateUserNotification(e:Event):void { completeUpdateUserNotification(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserNotification error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserNotification(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserNotification: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserNotification: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserNotification OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserNotification: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserNotification: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function updateWallTrainItem(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_WALL_TRAIN_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateWallTrainItem', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateWallTrainItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateWallTrainItem'); });
        function onCompleteUpdateWallTrainItem(e:Event):void { completeUpdateWallTrainItem(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateWallTrainItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateWallTrainItem(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateWallTrainItem: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateWallTrainItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateWallTrainItem OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateWallTrainItem: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateWallTrainItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateWallOrderItem(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_WALL_ORDER_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateWallOrderTime', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateWallOrderItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateWallOrderItem'); });
        function onCompleteUpdateWallOrderItem(e:Event):void { completeUpdateWallOrderItem(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateWallOrderTime error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateWallOrderItem(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateWallOrderTime: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateWallOrderTime: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateWallOrderTime OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateWallOrderTime: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateWallOrderTime: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserCraftCountTree (treeDbId:String,countCraft:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_CRAFT_COUNT_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserCraftCountTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = treeDbId;
        variables.craftedCount = countCraft;
        variables.hash = MD5.hash(String(g.user.userId)+String(treeDbId)+String(countCraft)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserCraftCountTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserCraftCountTree'); });
        function onCompleteUpdateUserCraftCountTree(e:Event):void { completeUpdateUserCraftCountTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserCraftCountTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserCraftCountTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserCraftCountTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserCraftCountTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserCraftCountTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserCraftCountTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserCraftCountTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserMusic(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_MUSIC);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserMusic', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.music = int(g.soundManager.isPlayingMusic);
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.music)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserMusic);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserMusic'); });
        function onCompleteUpdateUserMusic(e:Event):void { completeUpdateUserMusic(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserMusic error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserMusic(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserMusic: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMusic: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserMusic OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserMusic: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMusic: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserSound(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_SOUND);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserSound', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.sound = int(g.soundManager.isPlayingSound);
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.sound)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserSound);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserSound'); });
        function onCompleteUpdateUserSound(e:Event):void { completeUpdateUserSound(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserSound error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserSound(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserSound: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserSound: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserSound OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserSound: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserSound: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserCave(resourceId:int, count:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_CAVE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserCave', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.resourceId = resourceId;
        variables.count = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(resourceId)+String(count)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserCave);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserCave'); });
        function onCompleteAddUserCave(e:Event):void { completeAddUserCave(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserCave error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserCave(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserCave: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserCave: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserCave OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, d.status);
        } else {
            Cc.error('addUserCave: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserCave: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserCave(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_CAVE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserCave', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserCave);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserCave'); });
        function onCompleteGetUserCave(e:Event):void { completeGetUserCave(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserCave error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserCave(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ar:Array;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserCave: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserCave: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserCave OK', 5);
            if (callback != null) {
                callback.apply(null,[d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('userInfo: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftUserCave(resourceId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_USER_CAVE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftUserCave', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.resourceId = resourceId;
        variables.hash = MD5.hash(String(g.user.userId)+String(resourceId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftUserCave);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('craftUserCave'); });
        function onCompleteCraftUserCave(e:Event):void { completeCraftUserCave(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftUserCave error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeCraftUserCave(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftUserCave: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserCave: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'craftUserCave OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('craftUserCave: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserCave: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getAwayUserTreeWatering(id:int,userSocialId:String,callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_AWAY_USER_TREE_WATERING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getAwayUserTreeWatering', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.userSocialId = userSocialId;
        variables.id = id;
        variables.hash = MD5.hash(String(g.user.userId)+String(userSocialId)+String(id)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetAwayUserTreeWatering);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getAwayUserTreeWatering'); });
        function onCompleteGetAwayUserTreeWatering(e:Event):void { completeGetAwayUserTreeWatering(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getAwayUserTreeWatering error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetAwayUserTreeWatering(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getAwayUserTreeWatering: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAwayUserTreeWatering: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getAwayUserTreeWatering OK', 5);
            if (callback != null) {
                callback.apply(null,[d.message.state]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getAwayUserTreeWatering: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAwayUserTreeWatering: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function useHeroMouse(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USE_HERO_MOUSE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'useHeroMouse', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.count = g.user.countAwayMouse;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.count)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUseHeroMouse);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('useHeroMouse'); });
        function onCompleteUseHeroMouse(e:Event):void { completeUseHeroMouse(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('useHeroMouse error:' + error.errorID);
        }
    }

    private function completeUseHeroMouse(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('UseHeroMouse: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'UseHeroMouse: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'UseHeroMouse OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('UseHeroMouse: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function testGetUserFabric(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_TEST_USER_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'testGetUserFabric', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteTestGetUserFabric);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('testGetUserFabric'); });
        function onCompleteTestGetUserFabric(e:Event):void { completeTestGetUserFabric(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('testGetUserFabric error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeTestGetUserFabric(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('testGetUserFabric: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserFabricaRecipe: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'testGetUserFabric OK', 5);

            if (callback != null) {
                callback.apply(null,[d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('testGetUserFabric: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function setUserLevelToVK():void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SET_USER_LEVEL_VK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'setUserLevelToVK', 1);
        variables.level = g.user.level;
        variables.id = g.user.userSocialId;
        variables.channelId = g.socialNetworkID;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('setUserLevelToVK:' + error.errorID);
        }
    }

    public function getUserQuests(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_QUESTS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserQuests', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteGetUserQuests);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserQuests'); });
        function onСompleteGetUserQuests(e:Event):void { completeGetUserQuests(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserQuests error:' + error.errorID);
        }
    }

    private function completeGetUserQuests(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserQuests: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserQuests: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserQuests OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getUserQuests: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getUserNewQuests(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_NEW_QUESTS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserNewQuests', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.level = g.user.level;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserNewQuests);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserNewQuests'); });
        function onCompleteGetUserNewQuests(e:Event):void { completeGetUserNewQuests(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserNewQuests error:' + error.errorID);
        }
    }

    private function completeGetUserNewQuests(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserNewQuests: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserNewQuests: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserNewQuests OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getUserNewQuests: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateUserQuestTask(task:QuestTaskStructure, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_QUEST_TASK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserQuestTask', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.taskId = task.taskId;
        variables.countDone = task.countDone;
        if (task.isDone) variables.isDone = '1';
            else variables.isDone = '0';
        variables.hash = MD5.hash(String(g.user.userId) + String(variables.taskId) + String(variables.countDone) + SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserQuestTask);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserQuestTask'); });
        function onCompleteUpdateUserQuestTask(e:Event):void { completeUpdateUserQuestTask(e.target.data, task, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('UpdateUserQuestTask error:' + error.errorID);
        }
    }

    private function completeUpdateUserQuestTask(response:String, task:QuestTaskStructure, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('UpdateUserQuestTask: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'UpdateUserQuestTask: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'UpdateUserQuestTask OK', 5);
            if (callback != null) {
                callback.apply(null, [task]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('UpdateUserQuestTask: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function completeUserQuest(qId:int, qDBid:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_COMPLETE_USER_QUEST);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'completeUserQuest', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.questId = qId;
        variables.dbID = qDBid;
        variables.hash = MD5.hash(String(g.user.userId) + String(qId) + SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteCompleteUserQuest);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('completeUserQuest'); });
        function onCompleteCompleteUserQuest(e:Event):void { completeCompleteUserQuest(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('CompleteUserQuest error:' + error.errorID);
        }
    }

    private function completeCompleteUserQuest(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('CompleteUserQuest: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'CompleteUserQuest: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'CompleteUserQuest OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('CompleteUserQuest: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getUserQuestAward(qId:int, qDBid:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_QUEST_AWARD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserQuestAward', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.questId = qId;
        variables.dbID = qDBid;
        variables.hash = MD5.hash(String(g.user.userId) + String(qId) + SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserQuestAward);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserQuestAward'); });
        function onCompleteGetUserQuestAward(e:Event):void { completeGetUserQuestAward(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserQuestAward error:' + error.errorID);
        }
    }

    private function completeGetUserQuestAward(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserQuestAward: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserQuestAward: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'GetUserQuestAward OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserQuestAward: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function openUserOrder(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_OPEN_USER_ORDER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'openUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteOpenUserOrder);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('openUserOrder'); });
        function onСompleteOpenUserOrder(e:Event):void { completeOpenUserOrder(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserQuests error:' + error.errorID);
        }
    }

    private function completeOpenUserOrder(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('openUserOrder: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'openUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'openUserOrder OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('openUserORder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getChestYellow(id:int,callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CHEST_YELLOW);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getChestYellow', 1);
        variables = addDefault(variables);
        variables.id = id;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetChestYellow);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getChestYellow'); });
        function onCompleteGetChestYellow(e:Event):void { completeGetChestYellow(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getChestYellow error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetChestYellow(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getChestYellow: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getChestYellow: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getChestYellow OK', 5);
            if (callback != null) {
                callback.apply(null,[d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('userInfo: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getStarterPack(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_STARTER_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getChestYellow', 1);
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetStarterPack);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getStarterPack'); });
        function onCompleteGetStarterPack(e:Event):void { completeGetStarterPack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getChestYellow error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetStarterPack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getChestYellow: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getChestYellow: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getChestYellow OK', 5);
            if (callback != null) {
                callback.apply(null,[d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('userInfo: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataParty(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_DATA_PARTY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getDataParty', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataParty);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataParty'); });
        function onCompleteGetDataParty(e:Event):void { completeGetDataParty(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserEvent error:' + error.errorID);
        }
    }

    private function completeGetDataParty(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var obj:Object = {};
        var k:int = 0;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataParty: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataParty: wrong JSON:' + String(response));
            return;
        }
        for (var i:int = 0; i < d.message.length; i++) {
            obj = {};
            obj.id = d.message[i].id;
            obj.timeToStart = d.message[i].time_to_start;
            obj.timeToEnd = d.message[i].time_to_end;
//            if (i == 2) {
//                obj.timeToStart = TimeUtils.currentSeconds - 50;
//                obj.timeToEnd = TimeUtils.currentSeconds + 666;
//            }
            obj.levelToStart = int(d.message[i].level_to_start);
            obj.coefficient = int(d.message[i].coefficient);
            obj.typeParty = int(d.message[i].type_party);
            obj.idDecorBest = int(d.message[i].id_decor_best);
            obj.typeDecorBest = int(d.message[i].type_decor_best);
            obj.countDecorBest = int(d.message[i].count_decor_best);
            obj.filterOn = int(d.message[i].filter_on);
            obj.tester = Boolean(int(d.message[i].tester));
            obj.imMain = String(d.message[i].image_main);
            obj.imRating = String(d.message[i].image_rating);
            obj.imIcon = String(d.message[i].image_icon);
            obj.nameMain = int (d.message[i].text_id_name_main);
            obj.prevMain = int (d.message[i].text_id_prev_main);
            obj.descriptionMain = int (d.message[i].text_id_description_main);
            obj.textIdItem = int (d.message[i].text_id_item_main);
            obj.nameRating = int (d.message[i].text_id_name_rating);
            obj.descriptionRating = int (d.message[i].text_id_description_rating);
            obj.prevRating = int (d.message[i].text_id_prev_rating);
            obj.giftRating = int (d.message[i].text_id_gift_rating);

            if (d.message[i].id_item_event) obj.idItemEvent = String(d.message[i].id_item_event).split('&');
            for (k = 0; k < obj.idItemEvent.length; k++) obj.idItemEvent[k] = int(obj.idItemEvent[k]);

            if (d.message[i].id_gift) obj.idGift = String(d.message[i].id_gift).split('&');
            for (k = 0; k < obj.idGift.length; k++) obj.idGift[k] = int(obj.idGift[k]);

            if (d.message[i].type_gift) obj.typeGift = String(d.message[i].type_gift).split('&');
            for (k = 0; k < obj.typeGift.length; k++) obj.typeGift[k] = int(obj.typeGift[k]);

            if (d.message[i].count_gift) obj.countGift = String(d.message[i].count_gift).split('&');
            for (k = 0; k < obj.countGift.length; k++) obj.countGift[k] = int(obj.countGift[k]);

            if (d.message[i].count_to_gift) obj.countToGift = String(d.message[i].count_to_gift).split('&');
            for (k = 0; k < obj.countToGift.length; k++) obj.countToGift[k] = int(obj.countToGift[k]);
            g.managerParty.allArrParty.push(obj);
        }
        getUserParty(g.managerParty.findDataParty);
        getDataMiniParty(null);
        if (d.id == 0) {
            Cc.ch('server', 'getDataParty OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getDataParty: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateUserParty(friendId:String, friendCount:String, tookGift:String, countResource:int, showWindow:int, idPartyNew:int, idPartyOld:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_PARTY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserParty', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.friendId = friendId;
        variables.friendCount = friendCount;
        variables.countResource = countResource;
        variables.tookGift = tookGift;
        variables.showWindow = showWindow;
        variables.idPartyNew = idPartyNew;
        variables.idPartyOld = idPartyOld;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserParty);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserParty'); });
        function onCompleteUpdateUserParty(e:Event):void { completeUpdateUserParty(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserEvent error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserParty(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserParty: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserParty: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserEvent OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserParty: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserLevel: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserParty(callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_PARTY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserParty', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
//        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserParty);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserParty'); });
        function onCompleteGetUserParty(e:Event):void { completeGetUserParty(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserEvent error:' + error.errorID);
        }
    }

    private function completeGetUserParty(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var obj:Object = {};
        var k:int;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserParty: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserParty: wrong JSON:' + String(response));
            return;
        }
        for (var i:int = 0; i < d.message.length; i++) {
            obj = {};
            obj.countResource = int(d.message[i].count_resource);
            if (d.message[i].took_gift) obj.tookGift = String(d.message[i].took_gift).split('&');
            for (k = 0; k < obj.tookGift.length; k++) obj.tookGift[k] = int(obj.tookGift[k]);
            obj.showWindow = Boolean(int(d.message[i].show_window));
            obj.idParty = int(d.message[i].id_party);

            if (d.message[i].friend_id) {
                obj.friendId = String(d.message[i].friend_id).split('&');
                for (k = 0; k < obj.friendId.length; k++) obj.friendId[k] = int(obj.friendId[k]);
            } else obj.friendId = [];

            if (d.message[i].friend_count) {
                obj.friendCount = String(d.message[i].friend_count).split('&');
                for (k = 0; k < obj.friendCount.length; k++) obj.friendCount[k] = int(obj.friendCount[k]);
            } else obj.friendCount = [];
            g.managerParty.userParty.push(obj);
        }
        g.managerParty.userParty.sortOn("idParty", Array.DESCENDING | Array.NUMERIC);
        if (d.id == 0) {
            Cc.ch('server', 'getUserEvent OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getUserParty: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function onOKTransaction(callback:Function, isPayed:int, packId:int):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_OK_TRANSACTION);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'onOKTransaction', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userSocialId;
        variables.productCode = packId;
        variables.isPayed = isPayed;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteOKTransaction);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('onOKTransaction'); });
        function onCompleteOKTransaction(e:Event):void { completeOKTransaction(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserEvent error:' + error.errorID);
        }
    }

    private function completeOKTransaction(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('onOKTransaction: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'onOKTransaction: wrong JSON:' + String(response));
            return;
        }
        if (d.id == 0) {
            Cc.ch('server', 'onOKTransaction OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('onOKTransaction: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            //g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function onFBTransaction(callback:Function, isPayed:int, packId:int):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_OK_TRANSACTION);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'onFBTransaction', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userSocialId;
        variables.productCode = packId;
        variables.isPayed = isPayed;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteFBTransaction);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('onFBTransaction'); });
        function onCompleteFBTransaction(e:Event):void { completeFBTransaction(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserEvent error:' + error.errorID);
        }
    }

    private function completeFBTransaction(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('onFBTransaction: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'onFBTransaction: wrong JSON:' + String(response));
            return;
        }
        if (d.id == 0) {
            Cc.ch('server', 'onFBTransaction OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('onFBTransaction: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function deletePartyInPapper(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_PARTY_IN_PAPPER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deletePartyInPapper', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeletePartyInPapper);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('deletePartyInPaper'); });
        function onCompleteDeletePartyInPapper(e:Event):void { completeDeletePartyInPapper(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deletePartyInPapper error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeletePartyInPapper(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deletePartyInPapper: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deletePartyInPapper: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deletePartyInPapper OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deletePartyInPapper: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserEvent: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserError():void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_ERROR);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserError', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserError);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserError'); });
        function onCompleteAddUserError(e:Event):void { iconMouse.endConnect(); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserError error:' + error.errorID);
        }
    }

    public function getDataSalePack(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_DATA_SALE_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getDataSalePack', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataSalePack);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataSalePack'); });
        function onCompleteGetDataSalePack(e:Event):void { completeGetDataSalePack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataSalePack error:' + error.errorID);
        }
    }

    private function completeGetDataSalePack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var obj:Object;
        var k:int = 0;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataSalePack: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataSalePack: wrong JSON:' + String(response));
            return;
        }

        for (var i:int = 0; i < d.message.length; i++) {
            obj = {};
            obj.id = int(d.message[i].id);
            if (d.message[i].object_id) obj.objectId = String(d.message[i].object_id).split('&');
            for (k = 0; k < obj.objectId.length; k++) obj.objectId[k] = int(obj.objectId[k]);
            if (d.message[i].object_type) obj.objectType = String(d.message[i].object_type).split('&');
            for (k = 0; k < obj.objectType.length; k++) obj.objectType[k] = int(obj.objectType[k]);
            if (d.message[i].object_count) obj.objectCount = String(d.message[i].object_count).split('&');
            for (k = 0; k < obj.objectCount.length; k++) obj.objectCount[k] = int(obj.objectCount[k]);
            obj.oldCost = Number(d.message[i].old_cost);
            obj.newCost = Number(d.message[i].new_cost);
            obj.typeSale = int(d.message[i].type_sale);
            obj.isTester = Boolean(int(d.message[i].tester));
            obj.timeEvent = int(d.message[i].time_event);
//            if (!g.user.salePack && (obj.timeToEnd - TimeUtils.currentSeconds) > 0 && (obj.timeToStart - TimeUtils.currentSeconds) <= 0) g.userTimer.saleToEnd(obj.timeToEnd - TimeUtils.currentSeconds);
//            else if (obj.timeToStart > 0) g.userTimer.saleToStart(obj.timeToEnd - TimeUtils.currentSeconds);
            obj.profit = int(d.message[i].profit);
            obj.name = String(g.managerLanguage.allTexts[int(d.message[i].text_id_name)]);
            obj.description = String(g.managerLanguage.allTexts[int(d.message[i].text_id_description)]);
            g.managerSalePack.dataSale.push(obj);
        }
//        g.managerSalePack.dataSale.sortOn("id", Array.NUMERIC | Array.DESCENDING);
        if (d.id == 0) {
            Cc.ch('server', 'getDataSalePack OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getDataSalePack: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllFriendsInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataStockPack(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_DATA_STOCK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getDataSalePack', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataStockPack);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataStockPack'); });
        function onCompleteGetDataStockPack(e:Event):void { completeGetDataStockPack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataStockPack error:' + error.errorID);
        }
    }

    private function completeGetDataStockPack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataStockPack: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataStockPack: wrong JSON:' + String(response));
            return;
        }
        var b:Boolean = false;
        if (((int(d.message.time_start) - TimeUtils.currentSeconds < 0) && (int(d.message.time_end) - TimeUtils.currentSeconds > 0))) {
            g.userTimer.stockToEnd(int(d.message.time_end) - TimeUtils.currentSeconds);
            b = true;
        } else if ((int(d.message.time_start) - TimeUtils.currentSeconds) > 0) {
            g.userTimer.stockToStart(int(d.message.time_start) - TimeUtils.currentSeconds, int(d.message.time_end) - TimeUtils.currentSeconds);
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataStockPack OK', 5);
            if (callback != null) {
                callback.apply(null, [b]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getDataStockPack: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllFriendsInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserSalePack(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_SALE_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserSalePack', 1);
        variables = addDefault(variables);
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteUpdateUserSalePack);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserSalePack'); });
        function onСompleteUpdateUserSalePack(e:Event):void { completeUpdateUserSalePack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserSalePack error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserSalePack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserSalePack: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserSalePack: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserSalePack OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserSalePack: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTutorialStep: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserTrainPackNeedHelp(train_item_db_id:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TRAIN_PACK_HELP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTrainPackNeedHelp', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = train_item_db_id;
        variables.hash = MD5.hash(String(g.user.userId)+String(train_item_db_id)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTrainPackNeedHelp);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserTrainPackNeedHelp'); });
        function onCompleteUpdateUserTrainPackNeedHelp(e:Event):void { completeUpdateUserTrainPackNeedHelp(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTrainPackNeedHelp error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTrainPackNeedHelp(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTrainPackNeedHelp: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainPackNeedHelp: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTrainPackNeedHelp OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTrainPackNeedHelp: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainPackNeedHelp: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function updateTrainPackGetHelp(train_item_db_id:int, helpId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_TRAIN_PACK_GET_HELP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTrainPackGetHelp', 1);
        variables = addDefault(variables);
        if (!g.visitedUser) variables.userId = g.user.userId;
        else variables.userId = g.visitedUser.userId;

        variables.id = train_item_db_id;
        variables.helpId = helpId;
//        variables.hash = MD5.hash(String(g.visitedUser.userId)+String(helpId)+String(train_item_db_id)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTrainPackGetHelp);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateTrainPackGetHelp'); });
        function onCompleteUpdateUserTrainPackGetHelp(e:Event):void { completeUpdateUserTrainPackGetHelp(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTrainPackGetHelp error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTrainPackGetHelp(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTrainPackGetHelp: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainPackGetHelp: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTrainPackGetHelp OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTrainPackGetHelp: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainPackGetHelp: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function getAllTexts(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_ALL_TEXTS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getAllTexts', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.languageId = g.user.language;
//        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetAllTexts);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getAllTexts'); });
        function onCompleteGetAllTexts(e:Event):void { completeGetAllTexts(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getAllTexts error:' + error.errorID);
        }
    }

    private function completeGetAllTexts(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;

        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getAllTexts: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllTexts: wrong JSON:' + String(response));
            return;
        }
        for (var i:int = 0; i < d.message.length; i++) {
            g.managerLanguage.allTexts[int(d.message[i].id)] = d.message[i].text;
        }
        if (d.id == 0) {
            Cc.ch('server', 'getAllTexts OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getAllTexts: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function changeLanguage(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CHANGE_LANGUAGE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'changeLanguage', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
         variables.languageId = g.user.language;
//        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteChangeLanguage);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('changeLanguage'); });
        function onCompleteChangeLanguage(e:Event):void { completeChangeLanguage(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('changeLanguage error:' + error.errorID);
        }
    }

    private function completeChangeLanguage(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;

        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('changeLanguage: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'changeLanguage: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'changeLanguage OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('changeLanguage: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getDataAchievement(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_DATA_ACHIEVEMENT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getDataAchievement', 1);
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataAchievement);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataAchievement'); });
        function onCompleteGetDataAchievement(e:Event):void { completeGetDataAchievement(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataAchievement error:' + error.errorID);
        }
    }

    private function completeGetDataAchievement(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var k:int;
        var ob:Object;

        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataAchievement: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataAchievement: wrong JSON:' + String(response));
            return;
        }
        for (var i:int = 0; i < d.message.length; i++) {
            ob = {};
            ob.id = int(d.message[i].id);
            ob.name = String(g.managerLanguage.allTexts[d.message[i].text_id_name]);
            ob.description = String(g.managerLanguage.allTexts[d.message[i].text_id_description]);
            if (d.message[i].count_to_gift) ob.countToGift = String(d.message[i].count_to_gift).split('&');
            for (k = 0; k < ob.countToGift.length; k++) ob.countToGift[k] = int(ob.countToGift[k]);
            if (d.message[i].count_xp) ob.countXp = String(d.message[i].count_xp).split('&');
            for (k = 0; k < ob.countXp.length; k++) ob.countXp[k] = int(ob.countXp[k]);
            if (d.message[i].count_hard) ob.countHard = String(d.message[i].count_hard).split('&');
            for (k = 0; k < ob.countHard.length; k++) ob.countHard[k] = int(ob.countHard[k]);
            ob.typeAction = int(d.message[i].type_action);
            ob.idResource =  int(d.message[i].id_resource);
            if (Boolean(int(d.message[i].is_tester)) == false || (Boolean(int(d.message[i].is_tester)) == true && g.user.isTester)) g.managerAchievement.dataAchievement.push(ob);
            ob.priotity = 1000;
        }
        if (d.id == 0) {
            Cc.ch('server', 'getDataAchievement OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getDataAchievement: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getUserAchievement(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_ACHIEVEMENT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserAchievement', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserAchievement);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUseAchievement'); });
        function onCompleteGetUserAchievement(e:Event):void { completeGetUserAchievement(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserAchievement error:' + error.errorID);
        }
    }

    private function completeGetUserAchievement(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var k:int;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserAchievement: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserAchievement: wrong JSON:' + String(response));
            return;
        }
        for (var i:int = 0; i < d.message.length; i++) {
            ob = {};
            ob.id = int(d.message[i].achievement_id);
            ob.resourceCount =  int(d.message[i].resource_count);
            ob.showPanel = int(d.message[i].showPanel);
            if (d.message[i].took_gift) ob.tookGift = String(d.message[i].took_gift).split('&');
            for (k = 0; k < ob.tookGift.length; k++) ob.tookGift[k] = int(ob.tookGift[k]);
            g.managerAchievement.userAchievement.push(ob);
        }
        if (d.id == 0) {
            Cc.ch('server', 'getUserAchievement OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getUserAchievement: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateUserAchievement(achievementId:int, resourceCount:int, tookGift:String, showPanel:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_ACHIEVEMENT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserAchievement', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.achievementId = achievementId;
        variables.resourceCount = resourceCount;
        variables.tookGift = tookGift;
        variables.showPanel = showPanel;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserAchievement);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserAchievement'); });
        function onCompleteUpdateUserAchievement(e:Event):void { completeUpdateUserAchievement(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserAchievement error:' + error.errorID);
        }
    }

    private function completeUpdateUserAchievement(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var k:int;
        var ob:Object;
        ob = {};
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserAchievement: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAchievement: wrong JSON:' + String(response));
            return;
        }
        if (d.id == 0) {
            Cc.ch('server', 'updateUserAchievement OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserAchievement: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getDataCafe(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_BUILDING_FLIP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getDataCafe', 1);
        variables = addDefault(variables);
//        variables.userId = userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataCafe);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataCafe'); });
        function onCompleteGetDataCafe(e:Event):void { completeGetDataCafe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataCafe error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetDataCafe(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataCafe: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataCafe: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataCafe OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getDataCafe: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function getUserCafeRating(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_CAFE_RATING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserCafeRating', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserCafeRating);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserCafeRating'); });
        function onCompleteGetUserCafeRating(e:Event):void { completeGetUserCafeRating(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserCafeRating error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserCafeRating(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserCafeRating: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserCafeRating: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }
        g.managerCafe.arrRating = [];
        for (var i:int = 0; i < d.message.length; i++) {
            if (d.message[i].user_rating) {
                g.managerCafe.playerRatingPosition = int(d.message[i].user_rating);
                g.managerCafe.playerCount = int(d.message[i].user_count);
            }
            else {
                ob = {};
                ob.userId = int(d.message[i].user_id);
                ob.userSocialId = String(d.message[i].social_id);
                ob.count = int(d.message[i].count);
                ob.photo = d.message[i].photo_url;
                ob.name = String(d.message[i].name);
                ob.level = int(d.message[i].level);
                g.managerCafe.arrRating.push(ob);
                if (d.message[i].user_id == g.user.userId) {
                    g.managerCafe.playerRatingPosition = i + 1;
                    g.managerCafe.playerCount = int(d.message[i].count);
                }
            }
        }
        if (g.managerCafe.playerCount == -1) {
            g.managerCafe.playerRatingPosition = 300;
            g.managerCafe.playerCount = 0;
            addUserCafeRating(null);
        }
        if (d.id == 0) {
            Cc.ch('server', 'getUserCafeRating OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserCafeRating: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function getUserCafeItem(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_BUILDING_FLIP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserCafeItem', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserCafeItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserCafeItem'); });
        function onCompleteGetUserCafeItem(e:Event):void { completeGetUserCafeItem(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserCafeItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserCafeItem(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserCafeItem: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserCafeItem: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserCafeItem OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserCafeItem: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function getRatingParty(idParty:int, needaddArrBestPlayer:Boolean = true, callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_RATING_PARTY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getRatingParty', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.idParty = idParty;
//        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteGetRatingParty);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getRaitingParty'); });
        function onСompleteGetRatingParty(e:Event):void { completeGetRatingParty(e.target.data, needaddArrBestPlayer, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getRatingParty error:' + error.errorID);
        }
    }

    private function completeGetRatingParty(response:String, needaddArrBestPlayer:Boolean = true, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getRatingParty: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getRatingParty: wrong JSON:' + String(response));
            return;
        }
        var ob:Object;
        var i:int;
        if (needaddArrBestPlayer) {
            if (g.managerParty.arrBestPlayers && g.managerParty.arrBestPlayers.length > 0) {
                g.managerParty.arrBestPlayers = [];
            }
            for (i = 0; i < d.message.length; i++) {
                if (d.message[i] is Number) g.managerParty.playerPosition = int(d.message[i]);
                else {
                    if (d.message[i].user_id == g.user.userId) g.managerParty.playerPosition = i + 1;
                    ob = {};
                    ob.userId = int(d.message[i].user_id);
                    ob.userSocialId = String(d.message[i].social_id);
                    ob.countResource = int(d.message[i].count_resource);
                    ob.photo = d.message[i].photo_url;
                    ob.name = String(d.message[i].name);
                    ob.level = int(d.message[i].level);
                    g.managerParty.arrBestPlayers.push(ob);
                }
            }
        } else {
            for (i = 0; i < d.message.length; i++) {
                if (d.message[i] is Number) {
                    g.managerParty.setratingForEnd = int(d.message[i]);
                    break;
                }
                if (d.message[i].user_id == g.user.userId) {
                    g.managerParty.setratingForEnd = i + 1;
                    break;
                }
            }
        }
        if (d.id == 0) {
            Cc.ch('server', 'getRatingParty OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getRatingParty: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getNeighborFriends(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_NEIGHBOR_FRIENDS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getNeighborFriends', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
//        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteGetNeighborFriends);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getNeigborFriens'); });
        function onСompleteGetNeighborFriends(e:Event):void { completeGetNeighborFriends(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getNeighborFriends error:' + error.errorID);
        }
    }

    private function completeGetNeighborFriends(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getNeighborFriends: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getNeighborFriends: wrong JSON:' + String(response));
            return;
        }
        var arr:Array = [];
        var p:Someone;
        if (d.message) {
            for (var i:int = 0; i < d.message.length; i++) {
                p = new Someone;
                p.userId = int(d.message[i].user_id);
                p.userSocialId = String(d.message[i].social_id);
                p.name = String(d.message[i].name);
                p.lastName = String(d.message[i].last_name);
                p.level = int(d.message[i].level);
                p.globalXP = int(d.message[i].xp);
                arr.push(p);
            }
        }
        if (d.id == 0) {
            Cc.ch('server', 'getNeighborFriends OK', 5);
            if (callback != null) {
                callback.apply(null, [arr]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getNeighborFriends: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateNeighborFriends(callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_NEIGHBOR_FRIENDS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateNeighborFriends', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        if (g.friendPanel.arrNeighborFriends[0] && g.friendPanel.arrNeighborFriends[0].userId) variables.friend1 = g.friendPanel.arrNeighborFriends[0].userId;
            else variables.friend1 = 0;
        if (g.friendPanel.arrNeighborFriends[1] && g.friendPanel.arrNeighborFriends[1].userId) variables.friend2 = g.friendPanel.arrNeighborFriends[1].userId;
            else variables.friend2 = 0;
        if (g.friendPanel.arrNeighborFriends[2] && g.friendPanel.arrNeighborFriends[2].userId) variables.friend3 = g.friendPanel.arrNeighborFriends[2].userId;
            else variables.friend3 = 0;
        if (g.friendPanel.arrNeighborFriends[3] && g.friendPanel.arrNeighborFriends[3].userId) variables.friend4 = g.friendPanel.arrNeighborFriends[3].userId;
            else variables.friend4 = 0;
        if (g.friendPanel.arrNeighborFriends[4] && g.friendPanel.arrNeighborFriends[4].userId) variables.friend5 = g.friendPanel.arrNeighborFriends[4].userId;
            else variables.friend5 = 0;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateNeighborFriends);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateNeigborFriends'); });
        function onCompleteUpdateNeighborFriends(e:Event):void { completeUpdateNeighborFriends(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateNeighborFriends error:' + error.errorID);
        }
    }

    private function completeUpdateNeighborFriends(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateNeighborFriends: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getNeighborFriends: wrong JSON:' + String(response));
            return;
        }
        if (d.id == 0) {
            Cc.ch('server', 'updateNeighborFriends OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateNeighborFriends: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function FBgetUsersProfiles(usersIds:Array,callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_FB_USERS_PROFILE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'FBgetUsersProfiles', 1);
        variables = addDefault(variables);
        variables.ids = usersIds.join(',');
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteFBgetUsersProfiles);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('FBgetUsersProfiles'); });
        function onСompleteFBgetUsersProfiles(e:Event):void { completeFBgetUsersProfiles(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('FBgetUsersProfiles error:' + error.errorID);
        }
    }

    private function completeFBgetUsersProfiles(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('FBgetUsersProfiles: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'FBgetUsersProfiles: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'FBgetUsersProfiles OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('FBgetUsersProfiles: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateUserViralInvite(t:int,callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_VIRAL_INVITE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserViralInvite', 1);
        variables = addDefault(variables);
        variables.nextTime = t;
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteUpdateUserViralInvite);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserViralInvite'); });
        function onСompleteUpdateUserViralInvite(e:Event):void { completeUpdateUserViralInvite(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserViralInvite error:' + error.errorID);
        }
    }

    private function completeUpdateUserViralInvite(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('UpdateUserViralInvite: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'UpdateUserViralInvite: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'UpdateUserViralInvite OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('UpdateUserViralInvite: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getUserMiss(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_MISS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserViralInvite', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteGetUserMiss);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserMiss'); });
        function onСompleteGetUserMiss(e:Event):void { completeGetUserMiss(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserViralInvite error:' + error.errorID);
        }
    }

    private function completeGetUserMiss(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('UpdateUserViralInvite: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'UpdateUserViralInvite: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'UpdateUserViralInvite OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('UpdateUserViralInvite: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateUserMiss(userMissId:String = '', count_send:int = 0, send:Boolean = false, callback:Function = null):void {
    var loader:URLLoader = new URLLoader();
    var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_MISS);
    var variables:URLVariables = new URLVariables();

    Cc.ch('server', 'updateUserMiss', 1);
    variables = addDefault(variables);
    variables.userId = g.user.userId;
    variables.userMissId = userMissId;
    variables.countSend = count_send;
    variables.send = int(send);
    request.data = variables;
    request.method = URLRequestMethod.POST;
    iconMouse.startConnect();
    loader.addEventListener(Event.COMPLETE, onСompleteUpdateUserMiss);
    loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserMiss'); });
    function onСompleteUpdateUserMiss(e:Event):void { completeUpdateUserMiss(e.target.data, callback); }
    try {
        loader.load(request);
    } catch (error:Error) {
        Cc.error('updateUserMiss error:' + error.errorID);
    }
}

    private function completeUpdateUserMiss(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserMiss: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMiss: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserMiss OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserMiss: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateTimeStarterPack(timeStarterPack:int = 0,callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_TIME_STARTER_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserMiss', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
//        variables.hash = MD5.hash(String(g.user.userId)++SECRET);
        variables.timeStarterPack = timeStarterPack;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteUpdateTimeStarterPack);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserMiss'); });
        function onСompleteUpdateTimeStarterPack(e:Event):void { completeUpdateTimeStarterPack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserMiss error:' + error.errorID);
        }
    }

    private function completeUpdateTimeStarterPack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserMiss: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMiss: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserMiss OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserMiss: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function notificationVkMiss(userSocialId:String = '', callback:Function = null):void {
    var loader:URLLoader = new URLLoader();
    var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_NOTIFICATION_VK_MISS);
    var variables:URLVariables = new URLVariables();

    Cc.ch('server', 'notificationVkMiss', 1);
    variables = addDefault(variables);
    variables.userSocialId = userSocialId;
    request.data = variables;
    request.method = URLRequestMethod.POST;
    iconMouse.startConnect();
    loader.addEventListener(Event.COMPLETE, onСompleteNotificationVkMiss);
    loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('notificationVKMiss'); });
    function onСompleteNotificationVkMiss(e:Event):void { completeNotificationVkMiss(e.target.data, callback); }
    try {
        loader.load(request);
    } catch (error:Error) {
        Cc.error('notificationVkMiss error:' + error.errorID);
    }
}

    private function completeNotificationVkMiss(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        if (callback != null) {
            callback.apply();
        }
    }

    public function notificationFbMiss(userSocialId:String = '', callback:Function = null):void {
    var loader:URLLoader = new URLLoader();
    var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_NOTIFICATION_FB_MISS);
    var variables:URLVariables = new URLVariables();

    Cc.ch('server', 'notificationFbMiss', 1);
    variables = addDefault(variables);
    variables.userSocialId = userSocialId;
    request.data = variables;
    request.method = URLRequestMethod.POST;
    iconMouse.startConnect();
    loader.addEventListener(Event.COMPLETE, onСompleteNotificationFbMiss);
    loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('notificationFBMiss'); });
    function onСompleteNotificationFbMiss(e:Event):void { completeNotificationFbMiss(e.target.data, callback); }
    try {
        loader.load(request);
    } catch (error:Error) {
        Cc.error('notificationFbMiss error:' + error.errorID);
    }
}

    private function completeNotificationFbMiss(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        if (callback != null) {
            callback.apply();
        }
    }

    public function onShowAnnouncement(callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SHOW_ANNOUNCEMENT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'onShowAnnouncement', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteOnShowAnnouncement);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('onShowAnnouncement'); });
        function onСompleteOnShowAnnouncement(e:Event):void { completeOnShowAnnouncement(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('onShowAnnouncement error:' + error.errorID);
        }
    }

    private function completeOnShowAnnouncement(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        if (callback != null) {
            callback.apply();
        }
    }

    public function addNewPet(pet:PetMain, petHouseDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_NEW_PET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addNewPet', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.houseDbId = petHouseDbId;
        variables.petId = pet.petData.id;
        variables.hash = MD5.hash(String(g.user.userId)+String(petHouseDbId)+String(variables.petId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddNewPet);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addNewPet'); });
        function onCompleteAddNewPet(e:Event):void { completeAddNewPet(e.target.data, pet, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addNewPet error:' + error.errorID);
        }
    }

    private function completeAddNewPet(response:String, pet:PetMain, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addNewPet: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addNewPet: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addNewPet OK', 5);
            pet.dbId = int(d.message);
            if (callback != null)  callback.apply(null, [true]);
        } else if (d.id == 13) g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
          else if (d.id == 6) g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
          else {
            Cc.error('addNewPet: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getUserPet(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_PET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserPet', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserPet);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserPet'); });
        function onCompleteGetUserPet(e:Event):void { completeGetUserPet(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserPet error:' + error.errorID);
        }
    }

    private function completeGetUserPet(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserPet: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserPet: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserPet OK', 5);
            if (callback != null)
                callback.apply(null, [d]);
        } else if (d.id == 13) g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        else {
            Cc.error('GetUserAnimal: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function craftUserPet(pet:PetMain, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_USER_PET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftUserPet', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.petDbId = pet.dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.petDbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftUserPet);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('CraftUserPet'); });
        function onCompleteCraftUserPet(e:Event):void { completeCraftUserPet(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('CraftUserPet error:' + error.errorID);
        }
    }

    private function completeCraftUserPet(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('CraftUserPet: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'CraftUserPet: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'CraftUserPet OK', 5);
            if (callback != null)
                callback.apply();
        } else if (d.id == 13) g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        else {
            Cc.error('CraftUserAnimal: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function rawUserPet(p:PetMain, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RAW_USER_PET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'rawUserPet', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.petDbId = p.dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.petDbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRawUserPet);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('RawUserPet'); });
        function onCompleteRawUserPet(e:Event):void { completeRawUserPet(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('RawUserPet error:' + error.errorID);
        }
    }

    private function completeRawUserPet(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('RawUserPet: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'RawUserPet: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'RawUserPet OK', 5);
            if (callback != null)
                callback.apply();
        } else if (d.id == 13) g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        else {
            Cc.error('RawUserPet: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function rawUserPetDouble(p:PetMain, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RAW_USER_PET_DOUBLE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'rawUserPetDouble', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.petDbId = p.dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.petDbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRawUserPetDouble);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('RawUserPetDouble'); });
        function onCompleteRawUserPetDouble(e:Event):void { completeRawUserPetDouble(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('RawUserPetDouble error:' + error.errorID);
        }
    }

    private function completeRawUserPetDouble(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('RawUserPetDouble: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'RawUserPetDouble: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'RawUserPetDouble OK', 5);
            if (callback != null)
                callback.apply();
        } else if (d.id == 13) g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        else {
            Cc.error('RawUserPetDouble: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function rawUserPetAutoAfterFinish(p:PetMain, timeStart:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RAW_USER_PET_AUTO_AFTER_FINISH);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'rawUserUserPetAutoAfterFinish', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.petDbId = p.dbId;
        variables.timeStart=timeStart;
        p.hasNewEat ? variables.hasNewEat = 1 : variables.hasNewEat = 0;
        p.hasCraft ? variables.hasCraft = 1 : variables.hasCraft = 0;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.petDbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRawUserPetAutoAfterFinish);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('RawUserPetAutoAfterFinish'); });
        function onCompleteRawUserPetAutoAfterFinish(e:Event):void { completeRawUserPetAutoAfterFinish(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('RawUserPetAutoAfterFinish error:' + error.errorID);
        }
    }

    private function completeRawUserPetAutoAfterFinish(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('RawUserPetAutoAfterFinish: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'RawUserPetAutoAfterFinish: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'RawUserPetAutoAfterFinish OK', 5);
            if (callback != null)
                callback.apply();
        } else if (d.id == 13) g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        else {
            Cc.error('RawUserPetAutoAfterFinish: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function FBfake_getProfile(userSocialId:String = '', callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_FB_FAKE_GET_PROFILE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'FBfake_getProfile', 1);
        variables = addDefault(variables);
        variables.userSocialId = userSocialId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteFBfake_getProfile);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('FBfake_getProfile'); });
        function onСompleteFBfake_getProfile(e:Event):void { completeFBfake_getProfile(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('FBfake_getProfile error:' + error.errorID);
        }
    }

    private function completeFBfake_getProfile(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('FBfake_getProfile: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'FBfake_getProfile: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'FBfake_getProfile OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('FBfake_getProfile: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function FBfake_getAppUsers(callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_FB_FAKE_APP_USERS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'FBfake_getAppUsers', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteFBfake_getAppUsers);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('FBfake_getAppUsers'); });
        function onСompleteFBfake_getAppUsers(e:Event):void { completeFBfake_getAppUsers(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('FBfake_getAppUsers error:' + error.errorID);
        }
    }

    private function completeFBfake_getAppUsers(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('FBfake_getAppUsers: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'FBfake_getAppUsers: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'FBfake_getAppUsers OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('FBfake_getAppUsers: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function addUserSalePack(saleId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_SALE_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserSalePack', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.saleId = saleId;
//        variables.hash = MD5.hash(String(g.user.userId)+String(saleId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserSalePack);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserSalePack'); });
        function onCompleteAddUserSalePack(e:Event):void { completeAddUserSalePack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserSalePack error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserSalePack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserSalePack: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserSalePack: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserSalePack OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserSalePack: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserResource: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function getUserSalePack(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_SALE_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserSalePack', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserSalePack);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserSalePack'); });
        function onCompleteGetUserSalePack(e:Event):void { completeGetUserSalePack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserSalePack error:' + error.errorID);
        }
    }

    private function completeGetUserSalePack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserSalePack: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserSalePack: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserSalePack OK', 5);
            var ob:Object;
            for (var i:int = 0; i < d.message.length; i++) {
                ob = {};
                ob.id = int(d.message[i].id);
                ob.saleId = int(d.message[i].sale_id);
                ob.timeStart = int(d.message[i].time_start);
                ob.buy = Boolean(int(d.message[i].buy));
                g.managerSalePack.arrUserSale.push(ob);
                switch (ob.saleId) {
                    case 1:
                        g.managerSalePack.obRubies.buy1 = ob.buy;
                        g.managerSalePack.obRubies.showIts1 = true;
                        break;
                    case 2:
                        g.managerSalePack.obRubies.buy2 = ob.buy;
                        g.managerSalePack.obRubies.showIts2 = true;
                        break;
                    case 3:
                        g.managerSalePack.obRubies.buy3 = ob.buy;
                        g.managerSalePack.obRubies.showIts3 = true;
                        break;
                    case 4:
                        g.managerSalePack.obRubies.buy4 = ob.buy;
                        g.managerSalePack.obRubies.showIts4 = true;
                        break;
                    case 5:
                        g.managerSalePack.obRubies.buy5 = ob.buy;
                        g.managerSalePack.obRubies.showIts5 = true;
                        break;
                    case 6:
                        g.managerSalePack.obRubies.buy6 = ob.buy;
                        g.managerSalePack.obRubies.showIts6 = true;
                        break;
                    case 7:
                        g.managerSalePack.obRubies.buy7 = ob.buy;
                        g.managerSalePack.obRubies.showIts7 = true;
                        break;
                    case 8:
                        g.managerSalePack.obRubies.buy8 = ob.buy;
                        g.managerSalePack.obRubies.showIts8 = true;
                        break;
                    case 9:
                        g.managerSalePack.obRubies.buy9 = ob.buy;
                        g.managerSalePack.obRubies.showIts9 = true;
                        break;
                    case 10:
                        g.managerSalePack.obRubies.buy10 = ob.buy;
                        g.managerSalePack.obRubies.showIts10 = true;
                        break;
                        }
                }
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserSalePack: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getDataNews(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_DATA_NEWS);

        Cc.ch('server', 'start getDataNews', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteNews);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataNews'); });
        function onCompleteNews(e:Event):void { completeNews(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataNews error:' + error.errorID);
        }
    }

    private function completeNews(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataNews: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataNews: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataNews OK', 5);
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerNews.addArr(d.message[i]);
            }
            if (!g.tuts.isTuts) g.managerNews.checkNotificationBottomInterface();

            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataNews: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function updateUserNewsNew(news:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_NEWS_NEW);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserNewsNew', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.newsNew = news;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.newsNew)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateNewsNew);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserNewsNew'); });
        function onCompleteUpdateNewsNew(e:Event):void { completeUpdateNewsNew(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserNewsNew error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateNewsNew(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserNewsNew: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserNewsNew: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserNewsNew OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserNewsNew: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserNewsNew: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserParty(idParty:int,countResource:int, callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_PARTY);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'addUserParty', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.idParty = idParty;
        variables.countResource = countResource;
        variables.hash = MD5.hash(String(g.user.userId)+String(idParty)+String(countResource)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserParty);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserParty'); });
        function onCompleteAddUserParty(e:Event):void { completeAddUserParty(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserPapperBuy error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserParty(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserParty: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserParty: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserParty OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserParty: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserPapperBuy: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteUserParty(idParty:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_PARTY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserParty', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.idParty = idParty;
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserParty);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('deleteUserParty'); });
        function onCompleteDeleteUserParty(e:Event):void { completeDeleteUserParty(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserParty error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUserParty(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserParty: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserParty: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteUserParty OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deleteUserParty: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserSalePackBuy(buy:int, saleId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_SALE_PACK_BUY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserSalePackBuy', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buy = buy;
        variables.saleId = saleId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserSalePackBuy);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserSalePackBuy'); });
        function onCompleteUpdateUserSalePackBuy(e:Event):void { completeUpdateUserSalePackBuy(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserSalePackBuy error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserSalePackBuy(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserSalePackBuy: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserSalePackBuy: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserEvent OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserSalePackBuy: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserLevel: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getDataMiniParty(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_DATA_MINI_PARTY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getDataMiniParty', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataMiniParty);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getDataMiniParty'); });
        function onCompleteGetDataMiniParty(e:Event):void { completeGetDataMiniParty(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataMiniParty error:' + error.errorID);
        }
    }

    private function completeGetDataMiniParty(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var obj:Object = {};
        var k:int = 0;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataMiniParty: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataMiniParty: wrong JSON:' + String(response));
            return;
        }
        for (var i:int = 0; i < d.message.length; i++) {
            obj = {};
            obj.id = d.message[i].id;
            obj.timeToStart = d.message[i].time_start;
            obj.timeToEnd = d.message[i].time_end;
            obj.levelToStart = int(d.message[i].level);
            obj.typeMiniParty = int(d.message[i].type_mini_party);
            obj.tester = Boolean(int(d.message[i].tester));
            obj.iconUI = String(d.message[i].icon);
            obj.nameMain = int(d.message[i].txt_id_name);
            obj.countItem = int(d.message[i].count_item);
            obj.descriptionMain = int(d.message[i].txt_id_description);
            if (d.message[i].id_item) obj.idItemEvent = String(d.message[i].id_item).split('&');
            for (k = 0; k < obj.idItemEvent.length; k++) obj.idItemEvent[k] = int(obj.idItemEvent[k]);

            if (d.message[i].id_gift) obj.idGift = String(d.message[i].id_gift).split('&');
            for (k = 0; k < obj.idGift.length; k++) obj.idGift[k] = int(obj.idGift[k]);

            if (d.message[i].type_gift) obj.typeGift = String(d.message[i].type_gift).split('&');
            for (k = 0; k < obj.typeGift.length; k++) obj.typeGift[k] = int(obj.typeGift[k]);

            if (d.message[i].count_gift) obj.countGift = String(d.message[i].count_gift).split('&');
            for (k = 0; k < obj.countGift.length; k++) obj.countGift[k] = int(obj.countGift[k]);

            g.managerMiniParty.arrAllMiniParty.push(obj);
        }
       g.managerMiniParty.findDataParty();
        if (d.id == 0) {
            Cc.ch('server', 'getDataMiniParty OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getDataMiniParty: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function skipTimeOnRidgeParty(userId:int, plantTime:int,buildDbId:int, friendId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_RIDGE_PARTY);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();

        Cc.ch('server', 'skipTimeOnRidge', 1);
        variables = addDefault(variables);
        variables.userId = userId;
        variables.friendId = friendId;
        variables.plantTime = time - plantTime;
        variables.buildDbId = buildDbId;
        variables.hash = MD5.hash(String(userId)+String(variables.plantTime)+String(buildDbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipTimeOnRidgeParty);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('skipTimeOnRidge'); });
        function onCompleteSkipTimeOnRidgeParty(e:Event):void { completeSkipTimeOnRidgeParty(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnRidge error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipTimeOnRidgeParty(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnRidge: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnRidge: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipTimeOnRidge OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('skipTimeOnRidge: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnRidge: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserCafeRating(callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_ADD_CAFE_RATING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserCafeRating', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.count = g.managerCafe.playerCount;
//        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserCafeRating);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserCafeRating'); });
        function onCompleteAddUserCafeRating(e:Event):void { completeAddUserCafeRating(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserEvent error:' + error.errorID);
        }
    }

    private function completeAddUserCafeRating(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserCafeRating: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserCafeRating: wrong JSON:' + String(response));
            return;
        }
        if (d.id == 0) {
            Cc.ch('server', 'addUserCafeRating OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserCafeRating: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getUserCafeRatingFriend(arrClientUser:Array, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_CAFE_RATING_FRIEND);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserCafeRatingFriend', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.arrClientUser = arrClientUser.join('&');
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserCafeRatingFriend);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserCafeRatingFriend'); });
        function onCompleteGetUserCafeRatingFriend(e:Event):void { completeGetUserCafeRatingFriend(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserCafeRatingFriend error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserCafeRatingFriend(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserCafeRatingFriend: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserCafeRatingFriend: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }
        g.managerCafe.arrRatingFriend = [];
        if (d.message > 0) {
            for (var i:int = 0; i < d.message.length; i++) {
                if (g.user.userId == int(d.message[i].user_id)) {
                    ob = {};
                    ob.userId = g.user.userId;
                    ob.name = g.user.name;
                    ob.lastName = g.user.lastName;
                    ob.level = g.user.level;
                    ob.photo = g.user.photo;
                    ob.userSocialId = g.user.userSocialId;
                    ob.count = int(d.message[i].count);
                    ob.number = int(d.message[i].number);
                    g.managerCafe.arrRatingFriend.push(ob);
                } else {
                    for (var j:int = 0; j < g.user.arrFriends.length; j++) {
                        if (g.user.arrFriends[j].userId == int(d.message[i].user_id)) {
                            ob = {};
                            ob.userId = int(d.message[i].user_id);
                            ob.name = g.user.arrFriends[j].name;
                            ob.lastName = g.user.arrFriends[j].lastName;
                            ob.level = g.user.arrFriends[j].level;
                            ob.photo = g.user.arrFriends[j].photo;
                            ob.userSocialId = g.user.arrFriends[j].userSocialId;
                            ob.count = int(d.message[i].count);
                            ob.number = int(d.message[i].number);
                            g.managerCafe.arrRatingFriend.push(ob);
                            break;
                        }
                    }
                }
            }
        }

        getUserCafeRating(callback);
        if (d.id == 0) {
            Cc.ch('server', 'getUserCafeRatingFriend OK', 5);
//            if (callback != null) {
//                callback.apply(null, [true]);
//            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserCafeRatingFriend: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
//            if (callback != null) {
//                callback.apply(null);
//            }
        }
    }

    public function deleteUserOrderGift(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_ORDER_GIFT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserOrderGift);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('deleteUserOrder'); });
        function onCompleteDeleteUserOrderGift(e:Event):void { completeDeleteUserOrderGift(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserOrder error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUserOrderGift(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserOrder: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteUserOrder OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deleteUserOrder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserOrderGift(order:Object, delay:int, catId:int, txtId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_ORDER_GIFT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.catId = catId;
        variables.txtId = txtId;
        variables.ids = order.resourceIds.join('&');
        variables.counts = order.resourceCounts.join('&');
        variables.xp = order.xp;
        variables.coins = order.coins;
        variables.addCoupone = int(order.addCoupone);
        variables.delay = delay;
        variables.place = order.placeNumber;
        variables.fasterBuyer = order.fasterBuy;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.ids)+String(variables.counts)+String(variables.xp)+String(variables.coins)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserOrderGift);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('addUserOrder'); });
        function onCompleteAddUserOrderGift(e:Event):void { completeAddUserOrderGift(e.target.data, order, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserOrder error:' + error.errorID);
        }
    }

    private function completeAddUserOrderGift(response:String, order:Object, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserOrder: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserOrder OK', 5);
            order.dbId = String(d.message);
            if (callback != null) {
                callback.apply(null, [order]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserOrder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function getUserOrderGift(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_ORDER_GIFT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserOrderGift', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserOrderGift);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserOrderGift'); });
        function onCompleteGetUserOrderGift(e:Event):void { completeGetUserOrderGift(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserOrderGift error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserOrderGift(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserOrderGift: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserOrderGift: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserOrderGift OK', 5);
                if (d.message.length > 0) g.managerOrderCats.addFromServerGift(d.message[0]);
//            g.managerOrder.checkCatId();
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserOrderGift: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateCafeEnergyCount(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_CAFE_ENERGY_COUNT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateCafeEnergyCount', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.energyCount = g.user.cafeEnergyCount;
        variables.hash = MD5.hash(String(g.user.userId)+String(g.user.cafeEnergyCount)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateCafeEnergyCount);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateCafeEnergyCount'); });
        function onCompleteUpdateCafeEnergyCount(e:Event):void { completeUpdateCafeEnergyCount(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateCafeEnergyCount error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateCafeEnergyCount(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateCafeEnergyCount: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateCafeEnergyCount: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateCafeEnergyCount OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateCafeEnergyCount: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAmbar: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateCafeEnergyTime(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_CAFE_ENERGY_TIME);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateCafeEnergyTime', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateCafeEnergyTime);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateCafeEnergyTime'); });
        function onCompleteUpdateCafeEnergyTime(e:Event):void { completeUpdateCafeEnergyTime(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateCafeEnergyTime error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateCafeEnergyTime(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateCafeEnergyTime: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateCafeEnergyTime: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateCafeEnergyTime OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateCafeEnergyTime: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAmbar: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserCafeRating(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_CAFE_RATING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserCafeRating', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.count = g.managerCafe.playerCount;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserCafeRating);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserCafeRating'); });
        function onCompleteUpdateUserCafeRating(e:Event):void { completeUpdateUserCafeRating(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserCafeRating error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserCafeRating(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserCafeRating: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserCafeRating: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserCafeRating OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserCafeRating: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAmbar: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserCoinsMax(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_UPDATE_COINS_MAX);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserCoinsMax', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.coinsMax = g.user.coinsMax;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserCoinsMax);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserCoinsMax'); });
        function onCompleteUpdateUserCoinsMax(e:Event):void { completeUpdateUserCoinsMax(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserCoinsMax error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserCoinsMax(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserCoinsMax: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserCoinsMax: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserCoinsMax OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserCoinsMax: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAmbar: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserCountStand(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_UPDATE_COUNT_STAND);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserCountStand', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.countStand = g.user.countStand;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserCountStand);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserCountStand'); });
        function onCompleteUpdateUserCountStand(e:Event):void { completeUpdateUserCountStand(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserCountStand error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserCountStand(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserCountStand: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserCountStand: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserCountStand OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserCountStand: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAmbar: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserCoinsMaxRating(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_COINS_MAX_RATING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserCoinsMaxRating', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserCoinsMaxRating);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserCoinsMaxRating'); });
        function onCompleteGetUserCoinsMaxRating(e:Event):void { completeGetUserCoinsMaxRating(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserCoinsMaxRating error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserCoinsMaxRating(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserCoinsMaxRating: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserCoinsMaxRating: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }
        g.managerFarmStandCoinsMaxRating.arrCoinsMaxRating = [];
        for (var i:int = 0; i < d.message.length; i++) {
            if (d.message[i].user_rating) {
                g.managerFarmStandCoinsMaxRating.playerCoinsMaxRatingPosition = int(d.message[i].user_rating);
            }
            else {
                ob = {};
                ob.userId = int(d.message[i].user_id);
                ob.userSocialId = String(d.message[i].social_id);
                ob.count = int(d.message[i].coins_max);
                ob.photo = d.message[i].photo_url;
                ob.name = String(d.message[i].name);
                ob.level = int(d.message[i].level);
                g.managerFarmStandCoinsMaxRating.arrCoinsMaxRating.push(ob);
                if (d.message[i].user_id == g.user.userId) {
                    g.managerFarmStandCoinsMaxRating.playerCoinsMaxRatingPosition = i + 1;
                }
            }
        }
        if (d.id == 0) {
            Cc.ch('server', 'getUserCoinsMaxRating OK', 5);
            if (callback != null) {
                callback.apply(null,[true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserCoinsMaxRating: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function getUserFarmStandRating(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_FARM_STAND_RATING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserFarmStandRating', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserFarmStandRating);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserFarmStandRating'); });
        function onCompleteGetUserFarmStandRating(e:Event):void { completeGetUserFarmStandRating(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserFarmStandRating error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserFarmStandRating(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserFarmStandRating: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserFarmStandRating: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }
        g.managerFarmStandCoinsMaxRating.arrFarmStadRating = [];
        for (var i:int = 0; i < d.message.length; i++) {
            if (d.message[i].user_rating) {
                g.managerFarmStandCoinsMaxRating.playerCountStandRatingPosition = int(d.message[i].user_rating);
            }
            else {
                ob = {};
                ob.userId = int(d.message[i].user_id);
                ob.userSocialId = String(d.message[i].social_id);
                ob.count = int(d.message[i].count_stand);
                ob.photo = d.message[i].photo_url;
                ob.name = String(d.message[i].name);
                ob.level = int(d.message[i].level);
                g.managerFarmStandCoinsMaxRating.arrFarmStadRating.push(ob);
                if (d.message[i].user_id == g.user.userId) {
                    g.managerFarmStandCoinsMaxRating.playerCountStandRatingPosition = i + 1;
                }
            }
        }
        if (d.id == 0) {
            Cc.ch('server', 'getUserFarmStandRating OK', 5);
            if (callback != null) {
                callback.apply(null,[true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserFarmStandRating: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function getUserCoinsMaxFriendRating(arrClientUser:Array, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_COINS_MAX_RATING_FRIEND);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserCoinsMaxFriendRating', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.arrClientUser = arrClientUser.join('&');
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserCoinsMaxFriendRating);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserCoinsMaxFriendRating'); });
        function onCompleteGetUserCoinsMaxFriendRating(e:Event):void { completeGetUserCoinsMaxFriendRating(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserCoinsMaxFriendRating error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserCoinsMaxFriendRating(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserCoinsMaxFriendRating: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserCoinsMaxFriendRating: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }
        g.managerFarmStandCoinsMaxRating.arrCoinsMaxRatingFriend = [];
        if (d.message > 0) {
            for (var i:int = 0; i < d.message.length; i++) {
                if (g.user.userId == int(d.message[i].user_id)) {
                    ob = {};
                    ob.userId = g.user.userId;
                    ob.name = g.user.name;
                    ob.lastName = g.user.lastName;
                    ob.level = g.user.level;
                    ob.photo = g.user.photo;
                    ob.userSocialId = g.user.userSocialId;
                    ob.count = int(d.message[i].coins_max);
                    ob.number = int(d.message[i].number);
                    g.managerFarmStandCoinsMaxRating.arrCoinsMaxRatingFriend.push(ob);
                } else {
                    for (var j:int = 0; j < g.user.arrFriends.length; j++) {
                        if (g.user.arrFriends[j].userId == int(d.message[i].user_id)) {
                            ob = {};
                            ob.userId = int(d.message[i].user_id);
                            ob.name = g.user.arrFriends[j].name;
                            ob.lastName = g.user.arrFriends[j].lastName;
                            ob.level = g.user.arrFriends[j].level;
                            ob.photo = g.user.arrFriends[j].photo;
                            ob.userSocialId = g.user.arrFriends[j].userSocialId;
                            ob.count = int(d.message[i].coins_max);
                            ob.number = int(d.message[i].number);
                            g.managerFarmStandCoinsMaxRating.arrCoinsMaxRatingFriend.push(ob);
                            break;
                        }
                    }
                }
            }
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserCoinsMaxFriendRating OK', 5);
//            if (callback != null) {
//                callback.apply(null, [true]);
//            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserCoinsMaxFriendRating: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
//            if (callback != null) {
//                callback.apply(null);
//            }
        }
    }

    public function getUserFarmStandFriendRating(arrClientUser:Array, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_FARM_STAND_RATING_FRIEND);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserFarmStandFriendRating', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.arrClientUser = arrClientUser.join('&');
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserFarmStandFriendRating);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserFarmStandFriendRating'); });
        function onCompleteGetUserFarmStandFriendRating(e:Event):void { completeGetUserFarmStandFriendRating(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserFarmStandFriendRating error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserFarmStandFriendRating(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserFarmStandFriendRating: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserFarmStandFriendRating: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }
        g.managerFarmStandCoinsMaxRating.arrFarmStadRatingFriend = [];
        if (d.message > 0) {
            for (var i:int = 0; i < d.message.length; i++) {
                if (g.user.userId == int(d.message[i].user_id)) {
                    ob = {};
                    ob.userId = g.user.userId;
                    ob.name = g.user.name;
                    ob.lastName = g.user.lastName;
                    ob.level = g.user.level;
                    ob.photo = g.user.photo;
                    ob.userSocialId = g.user.userSocialId;
                    ob.count = int(d.message[i].count_stand);
                    ob.number = int(d.message[i].number);
                    g.managerFarmStandCoinsMaxRating.arrFarmStadRatingFriend.push(ob);
                } else {
                    for (var j:int = 0; j < g.user.arrFriends.length; j++) {
                        if (g.user.arrFriends[j].userId == int(d.message[i].user_id)) {
                            ob = {};
                            ob.userId = int(d.message[i].user_id);
                            ob.name = g.user.arrFriends[j].name;
                            ob.lastName = g.user.arrFriends[j].lastName;
                            ob.level = g.user.arrFriends[j].level;
                            ob.photo = g.user.arrFriends[j].photo;
                            ob.userSocialId = g.user.arrFriends[j].userSocialId;
                            ob.count = int(d.message[i].count_stand);
                            ob.number = int(d.message[i].number);
                            g.managerFarmStandCoinsMaxRating.arrFarmStadRatingFriend.push(ob);
                            break;
                        }
                    }
                }
            }
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserFarmStandFriendRating OK', 5);
//            if (callback != null) {
//                callback.apply(null, [true]);
//            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserFarmStandFriendRating: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
//            if (callback != null) {
//                callback.apply(null);
//            }
        }
    }

    public function getUserDecorRating(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_DECOR_RATING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserDecorRating', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserDecorRating);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserFarmStandRating'); });
        function onCompleteGetUserDecorRating(e:Event):void { completeGetUserDecorRating(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserDecorRating error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserDecorRating(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserDecorRating: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserDecorRating: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }
        g.managerDecorRating.arrDecorRating = [];
        for (var i:int = 0; i < d.message.length; i++) {
            if (d.message[i].user_rating) {
                g.managerDecorRating.playerPosition = int(d.message[i].user_rating);
            }
            else {
                ob = {};
                ob.userId = int(d.message[i].user_id);
                ob.userSocialId = String(d.message[i].social_id);
                ob.count = int(d.message[i].c);
                ob.photo = d.message[i].photo_url;
                ob.name = String(d.message[i].name);
                ob.level = int(d.message[i].level);
                g.managerDecorRating.arrDecorRating.push(ob);
                if (d.message[i].user_id == g.user.userId) {
                    g.managerDecorRating.playerPosition  = i + 1;
                }
            }
        }
        if (d.id == 0) {
            Cc.ch('server', 'getUserDecorRating OK', 5);
            if (callback != null) {
                callback.apply(null,[true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserDecorRating: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function getUserDecorFriendRating(arrClientUser:Array, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_DECOR_RATING_FRIEND);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserDecorFriendRating', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.arrClientUser = arrClientUser.join('&');
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserDecorFriendRating);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserDecorFriendRating'); });
        function onCompleteGetUserDecorFriendRating(e:Event):void { completeGetUserDecorFriendRating(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserDecorFriendRating error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserDecorFriendRating(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserDecorFriendRating: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserDecorFriendRating: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }
        g.managerDecorRating.arrFriendDecorRating = [];
        if (d.message > 0) {
            for (var i:int = 0; i < d.message.length; i++) {
                if (g.user.userId == int(d.message[i].user_id)) {
                    ob = {};
                    ob.userId = g.user.userId;
                    ob.name = g.user.name;
                    ob.lastName = g.user.lastName;
                    ob.level = g.user.level;
                    ob.photo = g.user.photo;
                    ob.userSocialId = g.user.userSocialId;
                    ob.count = int(d.message[i].count_stand);
                    ob.number = int(d.message[i].number);
                    g.managerDecorRating.arrFriendDecorRating.push(ob);
                } else {
                    for (var j:int = 0; j < g.user.arrFriends.length; j++) {
                        if (g.user.arrFriends[j].userId == int(d.message[i].user_id)) {
                            ob = {};
                            ob.userId = int(d.message[i].user_id);
                            ob.name = g.user.arrFriends[j].name;
                            ob.lastName = g.user.arrFriends[j].lastName;
                            ob.level = g.user.arrFriends[j].level;
                            ob.photo = g.user.arrFriends[j].photo;
                            ob.userSocialId = g.user.arrFriends[j].userSocialId;
                            ob.count = int(d.message[i].count_stand);
                            ob.number = int(d.message[i].number);
                            g.managerDecorRating.arrFriendDecorRating.push(ob);
                            break;
                        }
                    }
                }
            }
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserDecorFriendRating OK', 5);
//            if (callback != null) {
//                callback.apply(null, [true]);
//            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserDecorFriendRating: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
//            if (callback != null) {
//                callback.apply(null);
//            }
        }
    }

    public function updateUserDecorCount(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_UPDATE_DECOR_COUNT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserDecorCount', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.decorCount = g.user.decorCount;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserDecorCount);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserDecorCount'); });
        function onCompleteUpdateUserDecorCount(e:Event):void { completeUpdateUserDecorCount(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserCountStand error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserDecorCount(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserDecorCount: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserDecorCount: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserDecorCount OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserDecorCount: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAmbar: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserAnalytics(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_ANALYTICS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserAnalytics', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buyPaper = g.userAnalytics.buyPaper;
        variables.doneOrder = g.userAnalytics.doneOrder;
        variables.doneNyashuk = g.userAnalytics.doneNyashuk;
        variables.countSession = g.userAnalytics.countSession;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserAnalytics);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('updateUserAnalytics'); });
        function onCompleteUpdateUserAnalytics(e:Event):void { completeUpdateUserAnalytics(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserAnalytics error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserAnalytics(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserAnalytics: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAnalytics: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserAnalytics OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserAnalytics: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserSound: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserAnalytics(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_ANALYTICS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserAnalytics', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserAnalytics);
        loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:Event):void { internetNotWork('getUserAnalytics'); });
        function onCompleteGetUserAnalytics(e:Event):void { completeGetUserAnalytics(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('userInfo error:' + error.errorID);
        }
    }

    private function completeGetUserAnalytics(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserAnalytics: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserAnalytics: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserAnalytics OK', 5);
            var ob:Object = d.message;
            g.userAnalytics.buyPaper = int(d.message.buy_paper);
            g.userAnalytics.doneOrder = int(d.message.done_order);
            g.userAnalytics.doneNyashuk = int(d.message.done_nyashuk);
            g.userAnalytics.countSession = int(d.message.count_session);
            g.userAnalytics.countSession++;
            updateUserAnalytics(null);
            if (callback != null) callback.apply();
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('userInfo: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    private function wrongDataFromServer(st:String):void {
        new PreloadInfoTab('Wrong data');
        Cc.error('wrong data from server:: ' + st);
    }

    private function internetNotWork(scriptName:String):void {
        if (g.windowsManager) g.windowsManager.openWindow(WindowsManager.WO_SERVER_NO_WORK, null);
        else new PreloadInfoTab('Connection failed: ' + scriptName);
        Cc.error('no inet at: ' + scriptName);
    }
}
}
