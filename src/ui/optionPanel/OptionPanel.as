/**
 * Created by user on 7/27/15.
 */
package ui.optionPanel {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import flash.display.StageDisplayState;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import map.Containers;

import manager.Vars;

import map.MatrixGrid;

import mouse.ToolsModifier;

import starling.animation.Tween;
import starling.core.Starling;
import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.CSprite;

public class OptionPanel {
    private var _source:Sprite;
    private var _contFullScreen:CSprite;
    private var _contScalePlus:CSprite;
    private var _contScaleMinus:CSprite;
    private var _contScreenShot:CSprite;
    private var _contAnim:CSprite;
    private var _contMusic:CSprite;
    private var _contSound:CSprite;
    private var _arrCells:Array;

    private var g:Vars = Vars.getInstance();

    public function OptionPanel() {
        _arrCells = [/*.5,*/ .62, .8, 1, 1.25, 1.55];
        fillBtns();
    }

    private function fillBtns():void {
        _source = new Sprite();
        _source.x = g.managerResize.stageWidth;
        _source.y = g.managerResize.stageHeight - 557;
        g.cont.interfaceCont.addChild(_source);
        _source.visible = false;
        var im:Image;

        _contFullScreen = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("show_all_button"));
        _contFullScreen.addChild(im);
        _contFullScreen.y = 45;
        _source.addChild(_contFullScreen);
        _contFullScreen.hoverCallback = function ():void {
            if (g.tuts.isTuts) return;
            g.hint.showIt(String(g.managerLanguage.allTexts[488]));
        };
        _contFullScreen.outCallback = function ():void {
            if (g.tuts.isTuts) return;
            g.hint.hideIt();
        };
        _contFullScreen.startClickCallback = function ():void {
            if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) {
                _contFullScreen.removeChild(im);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("show_all_button"));
                _contFullScreen.addChild(im);
            } else {
                _contFullScreen.removeChild(im);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("show_all_button"));
                _contFullScreen.addChild(im);
            }
            onClick('fullscreen');
            g.hint.hideIt();
        };

        _contScalePlus = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("zoom_in_button"));
        _contScalePlus.addChild(im);
        _contScalePlus.y = 100;
        _source.addChild(_contScalePlus);
        _contScalePlus.hoverCallback = function ():void {
            if (g.tuts.isTuts) return;
            g.hint.showIt(String(g.managerLanguage.allTexts[489]));
        };
        _contScalePlus.outCallback = function ():void {
            if (g.tuts.isTuts) return;
            g.hint.hideIt();
        };
        _contScalePlus.endClickCallback = function ():void {
            onClick('scale_plus');
        };

        _contScaleMinus = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("zoom_out_button"));
        _contScaleMinus.addChild(im);
        _contScaleMinus.y = 155;
        _source.addChild(_contScaleMinus);
        _contScaleMinus.hoverCallback = function ():void {
            if (g.tuts.isTuts) return;
            g.hint.showIt(String(g.managerLanguage.allTexts[490]));
        };
        _contScaleMinus.outCallback = function ():void {
            if (g.tuts.isTuts) return;
            g.hint.hideIt();
        };
        _contScaleMinus.endClickCallback = function ():void {
            onClick('scale_minus');
        };

        _contMusic = new CSprite();
        if (g.soundManager.isPlayingMusic) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("music_on_button"));
        } else {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("music_off_button"));
        }
        _contMusic.addChild(im);
        _contMusic.y = 210;
        _source.addChild(_contMusic);
        _contMusic.hoverCallback = function ():void {
            if (g.soundManager.isPlayingMusic) {
                g.hint.showIt(String(g.managerLanguage.allTexts[493]));
            } else {
                g.hint.showIt(String(g.managerLanguage.allTexts[494]));
            }
        };
        _contMusic.outCallback = function ():void {
            g.hint.hideIt();
        };
        _contMusic.endClickCallback = function ():void {
            onClick('music');
        };

        _contSound = new CSprite();
        if (g.soundManager.isPlayingSound) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("sound_on_button"));
        } else {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("sound_off_button"));
        }
        _contSound.addChild(im);
        _contSound.y = 265;
        _source.addChild(_contSound);
        _contSound.hoverCallback = function ():void {
            if (g.soundManager.isPlayingSound) {
                g.hint.showIt(String(g.managerLanguage.allTexts[495]));
            } else {
                g.hint.showIt(String(g.managerLanguage.allTexts[496]));
            }
        };
        _contSound.outCallback = function ():void {
            g.hint.hideIt();
        };
        _contSound.endClickCallback = function ():void {
            onClick('sound');
        };
    }

    public function showIt():void {
        _source.visible = true;
        var tween:Tween = new Tween(_source, 0.2);
        _source.x = g.managerResize.stageWidth;
        tween.moveTo(_source.x - 70, _source.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);
    }

    public function hideIt():void {
        var tween:Tween = new Tween(_source, 0.2);
        tween.moveTo(_source.x + 70, _source.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            _source.visible = false;
        };
        g.starling.juggler.add(tween);
    }

    public function get isShowed():Boolean {
        return _source.visible;
    }

    private function onClick(reason:String):void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.managerSalePack) g.managerSalePack.onUserAction();
        if (g.managerStarterPack) g.managerStarterPack.onUserAction();
        var i:int;
        var im:Image;
        switch (reason) {
            case 'fullscreen':
                if (g.tuts.isTuts) return;
                if (g.managerCutScenes.isCutScene) return;
                g.bottomPanel.cancelBoolean(false);
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.toolsModifier.cancelMove();
                    try {
                        var func:Function = function(e:flash.events.Event):void {
                            Starling.current.nativeStage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, func);
                            makeFullScreen();
                            _contFullScreen.filter = null;
                        };
                        Starling.current.nativeStage.addEventListener(flash.events.MouseEvent.MOUSE_UP, func);
                    } catch (e:Error) {
                        Cc.ch('screen', 'Error:: Trouble with fullscreen: ' + e.message);
                    }
                break;
            case 'scale_plus':
                if (g.tuts.isTuts) return;
                if (g.managerCutScenes.isCutScene) return;
                g.bottomPanel.cancelBoolean(false);
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.toolsModifier.cancelMove();
                if (g.cont.isAnimScaling) return;
                i = _arrCells.indexOf(g.currentGameScale);
                if (i >= _arrCells.length-1) return;
                i++;
                g.cont.makeScaling(_arrCells[i]);
                break;
            case 'scale_minus':
                if (g.tuts.isTuts) return;
                if (g.managerCutScenes.isCutScene) return;
                g.bottomPanel.cancelBoolean(false);
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                g.toolsModifier.cancelMove();
                if (g.cont.isAnimScaling) return;
                i = _arrCells.indexOf(g.currentGameScale);
                if (i <= 0 ) return;
                i--;
                g.cont.makeScaling(_arrCells[i]);
                break;
            case 'screenshot':
                break;
            case 'anim':
                break;
            case 'music':
                while (_contMusic.numChildren) _contMusic.removeChildAt(0);
                g.soundManager.enabledMusic(!g.soundManager.isPlayingMusic);
                g.server.updateUserMusic(null);
                if (g.soundManager.isPlayingMusic) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("music_on_button"));
                    g.soundManager.managerMusic();
                } else {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("music_off_button"));
                }
                _contMusic.addChild(im);
                break;
            case 'sound':
                while (_contSound.numChildren) _contSound.removeChildAt(0);
                g.soundManager.enabledSound(!g.soundManager.isPlayingSound);
                g.server.updateUserSound(null);
                if (g.soundManager.isPlayingSound) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("sound_on_button"));
                } else {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("sound_off_button"));
                }
                _contSound.addChild(im);
                break;
        }
    }

    public function makeFullScreen():void {
        Cc.info('makeFullScreen');
        if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) {
            Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN;
        } else {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
        }
    }

    public function onResize():void {
        if (!_source) return;
        _source.x = g.managerResize.stageWidth;
        _source.y = g.managerResize.stageHeight - 557;
        if (_source.visible) _source.x -= 70;
    }


}
}
