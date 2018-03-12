/**
 * Created by user on 8/14/15.
 */
package ui.toolsPanel {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import flash.geom.Point;
import manager.Vars;
import mouse.ToolsModifier;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;

import tutorial.managerCutScenes.ManagerCutScenes;

import utils.CButton;
import windows.WOComponents.HorizontalPlawka;

public class ToolsPanel {

    private var _source:Sprite;
    private var _repositoryBtn:CButton;
    private var _flipBtn:CButton;
    private var _moveBtn:CButton;
    public var repositoryBox:RepositoryBox;
    private var _cutSceneCallback:Function;
    private var g:Vars = Vars.getInstance();

    public function ToolsPanel() {
        _source = new Sprite();
        g.cont.interfaceCont.addChildAt(_source, 0);
        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('map_editor_panel_left'), g.allData.atlas['interfaceAtlas'].getTexture('map_editor_panel_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('map_editor_panel_center'), 235);
        _source.addChild(pl);

        repositoryBox = new RepositoryBox();
        g.cont.interfaceCont.addChildAt(repositoryBox.source, 0);
        createBtns();
        _source.visible = false;
        _source.x = g.managerResize.stageWidth - 405;
        onResize();
    }

    private function createBtns():void {
        var im:Image;
        _repositoryBtn = new CButton();
//        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
//        _repositoryBtn.addDisplayObject(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('inventory_icon'));
//        im.x = 4;
//        im.y = 2;
        _repositoryBtn.setPivots();

        _repositoryBtn.x = 7 + _repositoryBtn.width/2;
        _repositoryBtn.y = 10 + _repositoryBtn.height/2;
        _repositoryBtn.addDisplayObject(im);
        _source.addChild(_repositoryBtn);
        _repositoryBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[499])); };
        _repositoryBtn.outCallback = function():void { g.hint.hideIt(); };
        _repositoryBtn.clickCallback = function():void {onClick('repository')};

        _flipBtn = new CButton();
//        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
//        _flipBtn.addDisplayObject(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rotate_icon'));
        _flipBtn.setPivots();
        _flipBtn.x = 70 + _flipBtn.width/2;
        _flipBtn.y = 10 + _flipBtn.height/2;
//        im.x = 4;
//        im.y = 4;
        _flipBtn.addDisplayObject(im);
        _source.addChild(_flipBtn);
        _flipBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[500])); };
        _flipBtn.outCallback = function():void { g.hint.hideIt(); };
        _flipBtn.clickCallback = function():void {onClick('flip')};

        _moveBtn = new CButton();
//        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
//        _moveBtn.addDisplayObject(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('move_icon'));
//        im.x = 5;
//        im.y = 3;
        _moveBtn.setPivots();
        _moveBtn.x = 133 + _moveBtn.width/2;
        _moveBtn.y = 10 + _moveBtn.height/2;
        _moveBtn.addDisplayObject(im);
        _source.addChild(_moveBtn);
        _moveBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[501])); };
        _moveBtn.outCallback = function():void { g.hint.hideIt(); };
        _moveBtn.clickCallback = function():void { onClick('move'); };
    }

    public function get isShowed():Boolean { return _source.visible; }
    public function hideRepository():void { repositoryBox.hideIt(); }
    public function getRepositoryBoxFirstItemProperties():Object { return repositoryBox.getRepositoryBoxPropertiesFirstItem(); }
    public function set cutSceneCallback(f:Function):void { _cutSceneCallback = f; }
    public function get repositoryBoxVisible():Boolean { return repositoryBox.source.visible; }

    public function onResize():void {
        if (!_source) return;
        _source.x = g.managerResize.stageWidth - 405;
        if (repositoryBox.source.visible) repositoryBox.source.y = g.managerResize.stageHeight - 83;
            else repositoryBox.source.y = g.managerResize.stageHeight + 10;
        repositoryBox.source.x = g.managerResize.stageWidth - 740;
        _source.y = g.managerResize.stageWidth + 10;
    }

    public function showIt(time:Number=.5, delay:Number = .2):void {
        if ((g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) && g.friendPanel.isShowed) {
            g.bottomPanel.boolFriend = true;
            g.friendPanel.hideIt();
        }
        _source.visible = true;
        TweenMax.killTweensOf(_source);
        new TweenMax(_source, time, {y:g.managerResize.stageHeight - 87});
    }

    public function hideIt(time:Number=.9):void {
        TweenMax.killTweensOf(_source);
        new TweenMax(_source, time, {y:g.managerResize.stageWidth + 10, ease:Back.easeOut, onComplete: function():void {_source.visible = false}});
    }

    private function onClick(reason:String):void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.managerSalePack) g.managerSalePack.onUserAction();
        if (g.managerStarterPack) g.managerStarterPack.onUserAction();
        switch (reason) {
            case 'repository':
                if (g.managerCutScenes.isCutScene && !g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_TO_INVENTORY_DECOR)
                        && !g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_FROM_INVENTORY_DECOR)) return;
                if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.toolsModifier.cancelMove();
                    return;
                }
                else  g.toolsModifier.modifierType = ToolsModifier.INVENTORY;


//                if(g.toolsModifier.modifierType != ToolsModifier.GRID_DEACTIVATED){
//                    if (repositoryBox.isShowed) hideRepository();
//                    else repositoryBox.showIt();
//                }
                if (g.buyHint.showThis) g.buyHint.hideIt();
                if (_cutSceneCallback != null) {
                    _cutSceneCallback.apply();
                }
                break;
            case 'move':
                if (g.managerCutScenes.isCutScene) return;
                if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.toolsModifier.cancelMove();
                    return;
                }
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.toolsModifier.cancelMove();
                }
                if(g.toolsModifier.modifierType != ToolsModifier.GRID_DEACTIVATED){
                    g.toolsModifier.modifierType == ToolsModifier.MOVE
                      ? g.toolsModifier.modifierType = ToolsModifier.NONE : g.toolsModifier.modifierType = ToolsModifier.MOVE;
                    if (repositoryBox.isShowed) hideRepository();
                }
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'flip':
                if (g.managerCutScenes.isCutScene) return;
                if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.toolsModifier.cancelMove();
                    return;
                }
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.toolsModifier.cancelMove();
                }
                if (g.toolsModifier.modifierType != ToolsModifier.GRID_DEACTIVATED){
                    g.toolsModifier.modifierType == ToolsModifier.FLIP
                      ? g.toolsModifier.modifierType = ToolsModifier.NONE : g.toolsModifier.modifierType = ToolsModifier.FLIP;
                    if (repositoryBox.isShowed) hideRepository();
                }
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
        }
    }

    public function getRepositoryBoxProperties():Object {
        var obj:Object = {};
        obj.x = _repositoryBtn.x - _repositoryBtn.width/2;
        obj.y = _repositoryBtn.y - _repositoryBtn.height/2;
        var p:Point = new Point(obj.x, obj.y);
        p = _source.localToGlobal(p);
        obj.x = p.x;
        obj.y = p.y;
        obj.width = _repositoryBtn.width;
        obj.height = _repositoryBtn.height;
        return obj;
    }

    public function pointXY():Point {
        var p:Point = new Point(-165,-5);
        p = _source.localToGlobal(p);
        return p;
    }
}
}
