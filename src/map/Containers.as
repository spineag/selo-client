/**
 * Created by user on 5/14/15.
 */
package map {
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.*;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import flash.geom.Point;
import mouse.ToolsModifier;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import tutorial.managerCutScenes.ManagerCutScenes;
import utils.CSprite;

public class Containers {
    public var SHIFT_MAP_X:int;
    public var SHIFT_MAP_Y:int;

    private var _mainCont:Sprite;
    public var backgroundCont:Sprite;
    public var gridDebugCont:Sprite;
    public var tailCont:CSprite;
    public var contentCont:CSprite;
    public var cloudsCont:Sprite;
    public var animationsCont:Sprite;
    public var craftCont:Sprite;
    public var craftAwayCont:Sprite;
    public var interfaceContMapEditor:Sprite;
    public var interfaceCont:Sprite;
    public var animationsContTop:Sprite;
    public var animationsContBottom:Sprite;
    public var animationsResourceCont:Sprite;
    public var windowsCont:Sprite;
    public var popupCont:Sprite;
    public var hintCont:Sprite;
    public var hintContUnder:Sprite;
    public var hintGameCont:Sprite;
    public var mouseCont:Sprite;
    private var _gameCont:Sprite;
    private var _gameContX:int;
    private var _gameContY:int;
    private var _gameContScale:Number;
    private var _isGameContTweening:Boolean;
    public var isAnimScaling:Boolean = false;
    private var _topGameContAnimation:Sprite;
//    private var _isMoving:Boolean = false;
    private var _startDragPoint:Point;
    private var _startDragPointCont:Point;
    

    private var g:Vars = Vars.getInstance();

    public function Containers() {
        _isGameContTweening = false;
        _gameContX = 0;
        _gameContY = 0;
        _gameContScale = 1;
        SHIFT_MAP_X = 186 * g.scaleFactor;
        SHIFT_MAP_Y = 590 * g.scaleFactor;

        _mainCont = new Sprite();
        _gameCont = new Sprite();
        backgroundCont = new Sprite();
        gridDebugCont = new Sprite();
        contentCont = new CSprite();
        craftCont = new Sprite();
        craftAwayCont = new Sprite();
        tailCont = new CSprite();
        animationsCont = new Sprite();
        cloudsCont = new Sprite();
        interfaceCont = new Sprite();
        animationsContBottom = new Sprite();
        animationsContTop = new Sprite();
        animationsResourceCont = new Sprite();
        windowsCont = new Sprite();
        popupCont = new Sprite();
        hintCont = new Sprite();
        hintContUnder = new Sprite();
        hintGameCont = new Sprite();
        mouseCont = new Sprite();
        interfaceContMapEditor = new Sprite();
        _topGameContAnimation = new Sprite();

        _mainCont.addChild(_gameCont);
        _gameCont.addChild(backgroundCont);
        _gameCont.addChild(gridDebugCont);
        _gameCont.addChild(tailCont);
        _gameCont.addChild(contentCont);
        _gameCont.addChild(craftCont);
        _gameCont.addChild(craftAwayCont);
        _gameCont.addChild(animationsCont);
        _gameCont.addChild(cloudsCont);
        _mainCont.addChild(hintGameCont);
        _mainCont.addChild(animationsContBottom);
        _mainCont.addChild(interfaceCont);
        _mainCont.addChild(interfaceContMapEditor);
        _mainCont.addChild(animationsContTop);
        _mainCont.addChild(hintContUnder);
        _mainCont.addChild(windowsCont);
        _mainCont.addChild(animationsResourceCont);
        _mainCont.addChild(_topGameContAnimation);
        _mainCont.addChild(hintCont);
        _mainCont.addChild(popupCont);
        _mainCont.addChild(mouseCont);

        g.mainStage.addChild(_mainCont);
        addGameContListener(true);
        craftAwayCont.touchable = false;
        craftAwayCont.visible = false;
    }
    
    public function onLoadAll():void {
        hideAll(false);
        _mainCont.addChildAt(_gameCont, 0);
    }
    
    public function hideAll(v:Boolean):void {
        hintGameCont.visible = !v;
        animationsContBottom.visible = !v;
        interfaceCont.visible = !v;
        interfaceContMapEditor.visible = !v;
        animationsContTop.visible = !v;
        hintContUnder.visible = !v;
        windowsCont.visible = !v;
        animationsResourceCont.visible = !v;
        hintCont.visible = !v;
        mouseCont.visible = !v;
    }

    public function addGameContListener(value:Boolean):void {
        if (value) {
            if (_gameCont.hasEventListener(TouchEvent.TOUCH)) return;
            _gameCont.addEventListener(TouchEvent.TOUCH, onGameContTouch);

        } else {
            if (!_gameCont.hasEventListener(TouchEvent.TOUCH)) return;
            _gameCont.removeEventListener(TouchEvent.TOUCH, onGameContTouch);
        }
    }

    public function get gameCont():Sprite { return _gameCont; }
    public function addToTopGameContAnimation(c:DisplayObjectContainer):void { if (!_topGameContAnimation.contains(c)) _topGameContAnimation.addChild(c); }
    public function removeFromTopGameContAnimation(c:DisplayObjectContainer):void { if (_topGameContAnimation.contains(c)) _topGameContAnimation.removeChild(c); }
    
    public function get gameContX():int {
        if (_isGameContTweening) return _gameCont.x;
        else return _gameContX;
    }
    
    public function get gameContY():int {
        if (_isGameContTweening) return _gameCont.y;
        else return _gameContY;
    }
    
    public function get gameContScale():int {
        if (_isGameContTweening) return _gameCont.scale;
        else return _gameContScale;
    }
    
    public function updateGameContVariables():void {
        _gameContX = _gameCont.x;
        _gameContY = _gameCont.y;
        _gameContScale = _gameCont.scale;
        _topGameContAnimation.x = _gameContX;
        _topGameContAnimation.y = _gameContY;
    }

    private var _isDragged:Boolean = false;
    private function onGameContTouch(te:TouchEvent):void {
        var p:Point;
        if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED && te.getTouch(_gameCont, TouchPhase.ENDED)) {
            p = te.touches[0].getLocation(g.mainStage);
            p.x -= _gameContX;
            p.y -= _gameContY;
            p = g.matrixGrid.getStrongIndexFromXY(p);
            g.deactivatedAreaManager.deactivateArea(p.x, p.y);
            g.ownMouse.showUsualCursor();
            return;
        }

        if (te.getTouch(_gameCont, TouchPhase.ENDED)) {
            onEnded();
        } else if (te.getTouch(_gameCont, TouchPhase.MOVED)) {
            if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE || g.toolsModifier.modifierType == ToolsModifier.CRAFT_PLANT) return;
            dragGameCont(te.touches[0].getLocation(g.mainStage));  // потрібно переписати перевірки на спосіб тачу
        } else if (te.getTouch(_gameCont, TouchPhase.BEGAN)) {
            if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED;
            _startDragPoint = te.touches[0].getLocation(g.mainStage); //te.touches[0].globalX;
            _startDragPointCont = new Point(_gameContX, _gameContY);
            if (g.ownMouse) g.ownMouse.showClickCursor();
            if (g.mouseHint) g.mouseHint.hideIt();
        } else if (te.getTouch(_gameCont, TouchPhase.HOVER)) {}
    }

    public function onEnded():void {
        checkOnDragEnd();
        g.ownMouse.showUsualCursor();
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE && !_isDragged && g.selectedBuild) {
            g.toolsModifier.onTouchEnded();
            return;
        }
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE || g.toolsModifier.modifierType == ToolsModifier.CRAFT_PLANT) {
            if (!_isDragged && !g.tuts.isTuts) {
                if (g.toolsModifier.modifierType != ToolsModifier.PLANT_SEED_ACTIVE) {
                    g.bottomPanel.cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    var arr:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
                    for (var i:int = 0; i < arr.length; i++) {
                        arr[i].lastBuyResource = false;
                    }
                } else {
                    g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED;
                }
            }
            _isDragged = false;
        }
        g.hideAllHints();
    }

    public function setDragPoints(p:Point):void {
        _startDragPoint = p;
        _startDragPointCont = new Point(_gameContX, _gameContY);
    }

    public function deleteDragPoint():void {
        _startDragPoint = null;
        _startDragPointCont = null;
    }

    public function dragGameCont(mouseP:Point):void {
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE || g.toolsModifier.modifierType == ToolsModifier.CRAFT_PLANT || _isGameContTweening) return;
        if (g.managerCutScenes.isCutScene && !g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_BUY_DECOR) && !g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_FROM_INVENTORY_DECOR)) return;
        g.hideAllHints(); // ??? not optimise
        if (_startDragPointCont == null || _startDragPoint == null) return;
        if (!_isDragged) if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(true);
        _isDragged = true;
        _gameCont.x = _startDragPointCont.x + mouseP.x - _startDragPoint.x;
        _gameCont.y = _startDragPointCont.y + mouseP.y - _startDragPoint.y;
        var oY:Number = g.matrixGrid.offsetY*_gameContScale;
        if (_gameCont.y > oY + SHIFT_MAP_Y*_gameContScale) _gameCont.y = oY + SHIFT_MAP_Y*_gameContScale;
        if (_gameCont.y < -g.realGameTilesHeight*_gameContScale - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*_gameContScale)
            _gameCont.y = -g.realGameTilesHeight*_gameContScale - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*_gameContScale;
        if (_gameCont.x > _gameContScale*g.realGameWidth/2 - _gameContScale*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*_gameContScale)
            _gameCont.x =  _gameContScale*g.realGameWidth/2 - _gameContScale*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*_gameContScale;
        if (_gameCont.x < -_gameContScale*g.realGameWidth/2 + _gameContScale*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + SHIFT_MAP_X*_gameContScale)
            _gameCont.x = -_gameContScale*g.realGameWidth/2 + _gameContScale*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + SHIFT_MAP_X*_gameContScale;
        updateGameContVariables();
    }
    
    public function checkOnDragEnd():void {
        if (_isDragged) {
            _isDragged = false;
            if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(false);
        }
    }

    public function moveCenterToXY(_x:int, _y:int, needQuick:Boolean = false, time:Number = .5, callback:Function = null):void {  // (_x, _y) - координати в загальній системі gameCont
        //переміщаємо ігрову область так, щоб вказана точка була по центру екрана
        var newX:int;
        var newY:int;
        var s:Number = _gameContScale;
        var oY:Number = g.matrixGrid.offsetY*s;
        newX = -(_x*s - g.managerResize.stageWidth/2);
        newY = -(_y*s - g.managerResize.stageHeight/2);
        if (newY > oY + SHIFT_MAP_Y*s) newY = oY + SHIFT_MAP_Y*s;
        if (newY < -g.realGameTilesHeight*s - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*s)
            newY = -g.realGameTilesHeight*s - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*s;
        if (newX > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s)
            newX =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*s;
        if (newX < -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + SHIFT_MAP_X*s)
            newX = -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + SHIFT_MAP_X*s;
        var f1:Function = function():void {
            _isGameContTweening = false;
            updateGameContVariables();
            if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(false);
            if (callback != null) {
                callback.apply();
            }
//            _isMoving= false;
        };
        if (needQuick) {
            _gameCont.x = newX;
            _gameCont.y = newY;
            updateGameContVariables();
            if (g.managerVisibleObjects) g.managerVisibleObjects.checkInStaticPosition();
        } else {
            if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(true);
            _isGameContTweening = true;
            new TweenMax(_gameCont, time, {x:newX, y:newY, ease:Linear.easeOut,onComplete: f1});
            new TweenMax(_topGameContAnimation, time, {x:newX, y:newY, ease:Linear.easeOut,onComplete: f1});
        }
    }

    public function killMoveCenterToPoint():void {
        TweenMax.killTweensOf(_gameCont);
        TweenMax.killTweensOf(_topGameContAnimation);
        _isGameContTweening = false;
        updateGameContVariables();
    }

    public function moveCenterToPos(posX:int, posY:int, needQuick:Boolean = false, time:Number = .5, callback:Function = null):void {
//        _isMoving = true;
        var p:Point = new Point(posX, posY);
        p = g.matrixGrid.getXYFromIndex(p);
        moveCenterToXY(p.x, p.y, needQuick, time, callback);
    }

    public function deltaMoveGameCont(deltaX:int, deltaY:int, time:Number = .5):void {
        var oY:Number = g.matrixGrid.offsetY*g.cont._gameCont.scaleX;
        var nX:int = _gameCont.x + deltaX;
        var nY:int = _gameCont.y + deltaY;
        if (nY > oY + SHIFT_MAP_Y*_gameCont.scaleX) nY = oY + SHIFT_MAP_Y*_gameCont.scaleX;
        if (nY < -g.realGameTilesHeight*_gameCont.scaleX - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*_gameCont.scaleX)
            nY = -g.realGameTilesHeight*_gameCont.scaleX - oY + g.managerResize.stageHeight + SHIFT_MAP_Y*_gameCont.scaleX;
        if (nX > _gameCont.scaleX*g.realGameWidth/2 - _gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*_gameCont.scaleX)
            nX = _gameCont.scaleX*g.realGameWidth/2 - _gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + SHIFT_MAP_X*_gameCont.scaleX;
        if (nX < -_gameCont.scaleX*g.realGameWidth/2 + _gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth - SHIFT_MAP_X*_gameCont.scaleX)
            nX = -_gameCont.scaleX*g.realGameWidth/2 + _gameCont.scaleX*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth - SHIFT_MAP_X*_gameCont.scaleX;
        var f1:Function = function():void {
            _isGameContTweening = false;
            updateGameContVariables();
        };
        _isGameContTweening = true;
        new TweenMax(_gameCont, time, {x:nX, y:nY, ease:Linear.easeOut, onComplete: f1});
        new TweenMax(_topGameContAnimation, time, {x:nX, y:nY, ease:Linear.easeOut, onComplete: f1});
    }

    public function onResize():void {
        var s:Number = _gameCont.scaleX;
        var oY:Number = g.matrixGrid.offsetY*s;
        if (_gameCont.y > oY + g.cont.SHIFT_MAP_Y*s) _gameCont.y = oY + g.cont.SHIFT_MAP_Y*s;
        if (_gameCont.y < -oY - g.realGameTilesHeight*s + g.managerResize.stageHeight + g.cont.SHIFT_MAP_Y*s)
            _gameCont.y = -oY - g.realGameTilesHeight*s + g.managerResize.stageHeight + g.cont.SHIFT_MAP_Y*s;
        if (_gameCont.x > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s)
            _gameCont.x =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s;
        if (_gameCont.x < -s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + g.cont.SHIFT_MAP_X*s)
            _gameCont.x =  -s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth + g.cont.SHIFT_MAP_Y*s;
        updateGameContVariables();
    }

    public function makeScaling(s:Number, sendToServer:Boolean = true, needQuick:Boolean = false):void {
        var p:Point;
        var pNew:Point;
        var oldScale:Number;
        var cont:Sprite = g.cont.gameCont;
        oldScale = cont.scaleX;
        if (oldScale > s-.05 && oldScale < s+.05) return;
        p = new Point();
        p.x = g.managerResize.stageWidth/2;
        p.y = g.managerResize.stageHeight/2;
        p = cont.globalToLocal(p);
        cont.scaleX = cont.scaleY = s;
        p = cont.localToGlobal(p);
        pNew = new Point();
        pNew.x = cont.x - p.x + g.managerResize.stageWidth/2;
        pNew.y = cont.y - p.y + g.managerResize.stageHeight/2;
        var oY:Number = g.matrixGrid.offsetY*s;

        if (pNew.y > oY + g.cont.SHIFT_MAP_Y*s) pNew.y = oY + g.cont.SHIFT_MAP_Y*s;
        if (pNew.y < oY - g.realGameHeight*s + g.managerResize.stageHeight + g.cont.SHIFT_MAP_Y*s)
            pNew.y = oY - g.realGameHeight*s + g.managerResize.stageHeight + g.cont.SHIFT_MAP_Y*s;
        if (pNew.x > s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s)
            pNew.x =  s*g.realGameWidth/2 - s*g.matrixGrid.DIAGONAL/2 + g.cont.SHIFT_MAP_X*s;
        if (pNew.x < -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth - g.cont.SHIFT_MAP_X*s)
            pNew.x =  -s*g.realGameWidth/2 + s*g.matrixGrid.DIAGONAL/2 + g.managerResize.stageWidth - g.cont.SHIFT_MAP_X*s;
        cont.scaleX = cont.scaleY = oldScale;
        g.currentGameScale = s;
        if (needQuick) {
            TweenMax.killTweensOf(cont);
            cont.scaleX = cont.scaleY = s;
            cont.x = pNew.x;
            cont.y = pNew.y;
            isAnimScaling = false;
        } else {
            isAnimScaling = true;
            if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(true);
            new TweenMax(cont, .5, {x: pNew.x, y: pNew.y, scaleX: s, scaleY: s, ease: Linear.easeOut, onComplete: function ():void {
                isAnimScaling = false;
                onResize();
                if (g.managerVisibleObjects) g.managerVisibleObjects.onActivateDrag(false);
            }});
        }
        if (sendToServer) {
            g.server.saveUserGameScale(null);
        }
        Cc.info('Game scale:: ' + s*100 + '%');
    }
}
}
