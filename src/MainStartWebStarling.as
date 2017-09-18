/**
 * Created by ndy on 16.03.2014.
 */
package {
import com.junkbyte.console.Cc;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.UncaughtErrorEvent;
import flash.system.Security;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import loaders.DataPath;

import loaders.EmbedAssets;
import loaders.LoadAnimationManager;
import loaders.LoaderManager;
import loaders.allLoadMb.AllLoadMb;

import manager.ManagerResize;
import manager.ownError.OwnErrorManager;

import map.Containers;
import manager.Vars;

import map.MatrixGrid;

import preloader.StartPreloader;

import server.DirectServer;

import social.SocialNetwork;
import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;

import starling.core.Starling;
import starling.events.Event;
import user.User;
import utils.ConsoleWrapper;

[SWF (frameRate='30', backgroundColor='#709e1d', width = '1000', height = '640')]
//[SWF (frameRate='30', backgroundColor='#000000', width = '1200', height = '800')]

public class MainStartWebStarling extends flash.display.Sprite{
    private var star:Starling;
    private var stageReady:Boolean = false;
    private var stageReadyInterval:int;
    private var game:MainStarling;
    private var g:Vars = Vars.getInstance();

    public function MainStartWebStarling() {
        loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, loaderInfo_uncaughtError);

        Security.allowDomain('*');
//        Security.allowInsecureDomain("*");
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        stage.addEventListener(flash.events.Event.RESIZE, onStageResize);
        stage.quality = StageQuality.MEDIUM;

        setTimeout(function() : void { if (!stageReady) onStageResize(null);}, 1000);
    }

    private function onStageResize(e:flash.events.Event):void {
        if (stageReadyInterval > 0) {
            clearTimeout(stageReadyInterval);
            stageReadyInterval = 0;
        }
        stageReadyInterval = setTimeout(startLoading, 500);

        function startLoading() : void {
            stage.removeEventListener(flash.events.Event.RESIZE, onStageResize);
            if (!stageReady) {
                Starling.multitouchEnabled = false;
                star = new Starling(MainStarling, stage);
                star.showStats = false;
                g.mainStage = star.stage;
                g.starling = star;
                star.simulateMultitouch = false;
                star.enableErrorChecking = false;
                star.skipUnchangedFrames = true;
                star.antiAliasing = 0;
                star.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
//                stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);
            }
        }
    }

    private function onRootCreated(event:starling.events.Event):void {
        ConsoleWrapper.getInstance().init(g.mainStage, this as Sprite);
        g.flashVars = stage.loaderInfo.parameters;
        Cc.obj('social', g.flashVars, 'vars from social network: ', 1);
        g.isDebug = stage.loaderInfo.url.substr(0, 4).toLowerCase() == 'file';
//        g.useHttps = g.isDebug ? false : (g.flashVars['protocol'] == 'https');
        Cc.ch('info', 'isDebug = ' + g.isDebug);
        g.user = new User();
        g.user.userGAcid = String(g.flashVars['gacid']);
        Cc.ch('analytic', 'gacid from flashvars:: ' + g.user.userGAcid);

        game = star.root as MainStarling;
        game.addEventListener(MainStarling.LOADED, onLoaded);
        star.start();

        ///// PART FOR GAME SCALE FACTOR  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // x2:: scaleFactor == 1
        // x1:: scaleFactor == .5
        g.scaleFactor = .5;
        g.realGameHeight *= g.scaleFactor;
        g.realGameWidth *= g.scaleFactor;
        g.realGameTilesHeight *= g.scaleFactor;
        g.realGameTilesWidth *= g.scaleFactor;
        ///// END OF PART FOR GAME SCALE FACTOR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   :)

        g.pBitmaps = {};
        new EmbedAssets(null);
        g.errorManager = new OwnErrorManager();
        g.cont = new Containers();
        g.matrixGrid = new MatrixGrid();
        g.matrixGrid.createMatrix();
        g.managerResize = new ManagerResize();
        g.managerResize.checkResizeOnStart();

        g.dataPath = new DataPath();
        g.loadMb = new AllLoadMb();
        g.load = LoaderManager.getInstance();
        g.pXMLs = {};
        g.pJSONs = {};
        g.loadAnimation = new LoadAnimationManager();
        g.directServer = new DirectServer();
        g.version = {};
        g.socialNetwork = new SocialNetwork(g.flashVars);
        
        if (g.isDebug) {
            g.socialNetworkID = SocialNetworkSwitch.SN_FB_ID;
        } else {
            g.socialNetworkID = int(g.flashVars['channel']);
        }
        
        g.startPreloader = new StartPreloader(onPreload);
    }

    private function onPreload():void {
        SocialNetworkSwitch.init(g.socialNetworkID, g.flashVars, g.isDebug);
        g.socialNetwork.addEventListener(SocialNetworkEvent.INIT, onSocialNetworkInit);
        g.socialNetwork.init();
    }

    private function onSocialNetworkInit(e:SocialNetworkEvent = null):void {
        g.startPreloader.setProgress(2);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.INIT, onSocialNetworkInit);
        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_PROFILES, authoriseUser);
        g.socialNetwork.getProfile(g.socialNetwork.currentUID);
    }

    private function authoriseUser(e:SocialNetworkEvent = null):void {
        Cc.info('userSocialId == ' + g.socialNetwork.currentUID + " --- " + g.user.userSocialId); // should be the same
        g.socialNetwork.checkUserLanguageForIFrame();
        g.startPreloader.setProgress(3);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_PROFILES, authoriseUser);
        g.directServer.authUser(game.start);
    }

    private function onLoaded(event : starling.events.Event):void {
        game.removeEventListener(MainStarling.LOADED, onLoaded);
    }

//    private function onStageDeactivate(e:Event):void {
//        star.stop();
//        stage.addEventListener(flash.events.Event.ACTIVATE, onStageActivate, false, 0, true);
//    }
//
//    private function onStageActivate(e:Event):void {
//        stage.removeEventListener(flash.events.Event.ACTIVATE, onStageActivate);
//        star.start();
//    }

    private function loaderInfo_uncaughtError(event:UncaughtErrorEvent) : void
    {
//        Cc.logch("Error", event.error, event.errorID, event);
//        Cc.logch("Error", (event.error as Error).getStackTrace());
    }

}
}
