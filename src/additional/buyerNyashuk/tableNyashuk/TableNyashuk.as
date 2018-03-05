/**
 * Created by user on 10/25/17.
 */
package additional.buyerNyashuk.tableNyashuk {
import build.WorldObject;

import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;

import hint.FlyMessage;

import manager.ManagerFilters;

import manager.Vars;

import media.SoundConst;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

public class TableNyashuk {
    private var _source:CSprite;
    private var _posX:int;
    private var _posY:int;
    private var _armature:Armature;
    private var g:Vars = Vars.getInstance();
    private var _spriteTxt:Sprite;
    private var _isHover:Boolean;

    public function TableNyashuk() {
        _source = new CSprite();
        _isHover = false;
        _spriteTxt = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('clock'));
        MCScaler.scale(im, im.height - 35, im.width - 35);
        im.pivotX = im.pivotY = im.width/2;
        im.y = 2;
        _spriteTxt.addChild(im);
        _source.visible = false;
        if (g.allData.factory['table']) onLoad();
         else g.loadAnimation.load('animations_json/x1/table', 'table', onLoad);
    }

        private function onLoad():void {
            _armature = new Armature();
            _armature = g.allData.factory['table'].buildArmature("table");
            _source.addChild(_armature.display as StarlingArmatureDisplay);
            _source.releaseContDrag = true;
            if (!g.isAway) {
                _source.endClickCallback = onClick;
                _source.hoverCallback = onHover;
                _source.outCallback = onOut;
            }
            WorldClock.clock.add(_armature);

            var b:Slot = _armature.getSlot('check');
            if (b) {
                b.displayList = null;
                b.display = _spriteTxt;
            }
        }

    private function onClick():void {
        if (g.isAway) return;
        g.soundManager.playSound(SoundConst.EMPTY_CLICK);
        var p:Point = new Point(g.ownMouse.mouseX, g.ownMouse.mouseY);
        p.y -= 50;
        new FlyMessage(p,String(g.managerLanguage.allTexts[1155]));
        return;
    }

    public function showTable(b:Boolean = false, pX:int=0, pY:int=0):void {
        _source.visible = b;
        _posX = pX;
        _posY = pY;
    }

    public function get posX():int { return _posX; }
    public function get posY():int { return _posY; }
    public function get source():CSprite { return _source; }

    public function onHover():void {
        if (_isHover) return;
        _isHover = true;
        var fEndOver:Function = function(e:Event=null):void {
            _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
        };
        _armature.addEventListener(EventObject.COMPLETE, fEndOver);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
        _armature.animation.gotoAndPlayByFrame('over');
        g.hint.showIt(String(g.managerLanguage.allTexts[1155]));
    }

    public function onOut():void {
        _isHover = false;
        g.hint.hideIt();
    }



}
}
