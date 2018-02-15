/**
 * Created by user on 11/21/17.
 */
package hint {
import additional.pets.PetMain;
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import manager.Vars;
import starling.animation.Tween;
import starling.display.Image;
import starling.display.Quad;
import starling.utils.Align;
import starling.utils.Color;
import tutorial.TutsAction;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.SimpleArrow;
import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class PetHint {
    private var _source:CSprite;
    private var _btn:CButton;
    private var _isShowed:Boolean;
    private var _isOnHover:Boolean;
    private var _iconResource:Image;
    private var _txtCount:CTextField;
    private var _txtCountAll:CTextField;
    private var _txtName:CTextField;
    private var _deleteCallback:Function;
    private var _id:int;
    private var _height:int;
    private var _closeTime:Number;
    private var bg:HintBackground;
    private var g:Vars = Vars.getInstance();
    private var _quad:Quad;
    private var _onOutCallback:Function;
    private var _canHide:Boolean;
    private var _arrow:SimpleArrow;
    private var _petMain:PetMain;

    public function PetHint() {
        _canHide = true;
        _source = new CSprite();
        _btn = new CButton();
        _isShowed = false;
        _isOnHover = false;
        bg = new HintBackground(120, 125, HintBackground.BIG_TRIANGLE, HintBackground.BOTTOM_CENTER);
        _source.addChild(bg);
        _source.addChild(_btn);
        _txtCount = new CTextField(80,50,"");
        _txtCount.setFormat(CTextField.BOLD18, 18,Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCount.alignH = Align.LEFT;
        _source.addChild(_txtCount);

        _txtCountAll = new CTextField(80,50, '/1');
        _txtCountAll.setFormat(CTextField.BOLD18, 18,Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountAll.alignH = Align.LEFT;
        _txtCountAll.y = -68;
        _source.addChild(_txtCountAll);

        _txtName = new CTextField(120,50,"");
        _txtName.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtName.x = -60;
        _txtName.y = -157;
        _source.addChild(_txtName);
        _btn.clickCallback = onClick;
        _source.outCallback = onOutHint;
        _source.hoverCallback = onHover;
        _btn.x = -33;
        _btn.y = -115;
    }

    public function showIt(height:int,x:int,y:int, idResourceForRemoving:int, name:String, out:Function, p:PetMain):void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.managerSalePack) g.managerSalePack.onUserAction();
        if (g.managerStarterPack) g.managerStarterPack.onUserAction();
        if (_isShowed) return;
        _id = idResourceForRemoving;
        _isShowed = true;
        _height = height;
        _petMain = p;
        _onOutCallback = out;
        _quad = new Quad(int(bg.width), int(bg.height + _height * g.currentGameScale), Color.WHITE);
        _quad.alpha = 0;
        _quad.x = -int(bg.width/2);
        _quad.y = -bg.height;
        _source.addChildAt(_quad,0);
        if (!g.allData.getResourceById(idResourceForRemoving)) {
            Cc.error('petHint showIt:: no such g.dataResource.objectResources[idResourceForRemoving] for idResourceForRemoving: ' + idResourceForRemoving);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'petHint');
            return;
        }
        _txtName.text = name;
        if (g.allData.getResourceById(idResourceForRemoving).buildType == BuildType.PLANT) _iconResource = new Image(g.allData.atlas['resourceAtlas'].getTexture(String(g.allData.getResourceById(idResourceForRemoving).imageShop) + '_icon'));
        else _iconResource = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(idResourceForRemoving).imageShop));

        _txtCount.text = String(g.userInventory.getCountResourceById(idResourceForRemoving));
        _txtCount.x = -18;
        _txtCount.y = -68;
        _txtCountAll.x = _txtCount.x + _txtCount.textBounds.width - 3;
        if (g.userInventory.getCountResourceById(idResourceForRemoving) > 0) {
            _txtCount.changeTextColor =  Color.WHITE;
            _txtCount.changeTextStroke = ManagerFilters.BLUE_COLOR;
        } else {
            _txtCount.changeTextColor = ManagerFilters.RED_TXT_NEW;
            _txtCount.changeTextStroke = Color.WHITE;
        }
        if (g.allData.getResourceById(idResourceForRemoving).buildType == BuildType.PLANT) _iconResource = new Image(g.allData.atlas['resourceAtlas'].getTexture(String(g.allData.getResourceById(idResourceForRemoving).imageShop) + '_icon'));
        else _iconResource = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(idResourceForRemoving).imageShop));
        if (!_iconResource) {
            Cc.error('petHint showIt:: no such image: ' + g.allData.getResourceById(idResourceForRemoving).imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'petHint');
            return;
        }
        MCScaler.scale(_iconResource, 65, 65);
        _btn.addChild(_iconResource);
        _source.x = x;
        _source.y = y;
        g.cont.hintGameCont.addChild(_source);
        _source.scaleX = _source.scaleY = 0;
        var tween:Tween = new Tween(_source, 0.1);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);
    }

    public function hideIt():void {
        if (!_canHide) return;
        if (_isOnHover) return;
        if (g.tuts.isTuts && g.tuts.action == TutsAction.REMOVE_WILD) return;
        _closeTime = 1.5;
        g.gameDispatcher.addToTimer(closeTimer);
    }

    private function closeTimer():void {
        _closeTime--;
        if (_closeTime <= 0) {
            if (!_isOnHover) {
                var tween:Tween = new Tween(_source, 0.1);
                tween.scaleTo(0);
                tween.onComplete = function ():void {
                    g.starling.juggler.remove(tween);
                    _isShowed = false;
                    if (g.cont.hintGameCont.contains(_source))
                        g.cont.hintGameCont.removeChild(_source);
                    _source.removeChild(_quad);
                    _btn.removeChild(_iconResource);
                    _iconResource = null;
                    _height = 0;
                };
                g.starling.juggler.add(tween);
            }
            g.gameDispatcher.removeFromTimer(closeTimer);
        }
    }

    private function onClick(id:int = 0):void {
        if (g.userInventory.getCountResourceById(_id) <= 0){
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, _onOutCallback, 'raw_pet', {pet: _petMain});
        } else {
            if (_onOutCallback != null) {
                _onOutCallback.apply(null, [_petMain]);
                _onOutCallback = null;
            }
            managerHide();
        }
    }

    public function get isShow():Boolean { return _isShowed; }
    public function set onDelete(f:Function):void { _deleteCallback = f; }
    private function onHover():void { _isOnHover = true; }
    private function onOutHint():void {
        _isOnHover = false;
        hideIt();
    }

    public function managerHide(callback:Function = null):void {
        if (_isShowed) {
            if (g.tuts.isTuts && g.tuts.action == TutsAction.REMOVE_WILD) return;

            var tween:Tween = new Tween(_source, 0.1);
            tween.scaleTo(0);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
                _isShowed = false;
                if (g.cont.hintGameCont.contains(_source))
                    g.cont.hintGameCont.removeChild(_source);
                _source.removeChild(_quad);
                _btn.removeChild(_iconResource);
                _iconResource = null;
                _height = 0;
                if (callback != null) {
                    callback.apply();
                    callback = null;
                }
            };
            g.starling.juggler.add(tween);
            g.gameDispatcher.removeFromTimer(closeTimer);
        }
    }

    public function addArrow():void {
        _canHide = false;
        if (_btn && !_arrow) {
            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
            _arrow.animateAtPosition(_btn.x + _btn.width/2, _btn.y - _btn.height/2 - 2);
            _arrow.scaleIt(.7);
        }
    }

    public function hideArrow():void {
        _canHide = true;
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }
}
}