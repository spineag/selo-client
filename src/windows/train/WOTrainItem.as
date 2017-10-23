/**
 * Created by user on 7/24/15.
 */
package windows.train {
import build.train.TrainCell;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.StructureDataResource;

import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;
import social.SocialNetwork;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import user.Someone;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class WOTrainItem {
    private var _source:CSprite;
    private var _info:TrainCell;
    private var _txtCount:CTextField;
    private var _index:int;
    private var _f:Function;
    private var _isHover:Boolean;
    private var _needHelp:Image;
    private var _imClosed:Image;
    private var _imOpen:Image;
    private var _imResource:Image;
    private var _imPlawka:Image;
    private var _dataResource:StructureDataResource;
    private var _personBuyer:Someone;
    private var _ava:Image;

    private var g:Vars = Vars.getInstance();

    public function WOTrainItem(type:int, i:int) {
        _index = i;
        _source = new CSprite();
        var st1:String;
        var st2:String;
        if (type == WOTrain.CELL_WHITE) {      st1 = 'White_packet_closed'; st2 = 'White_packet_open'; }
        else if (type == WOTrain.CELL_GREEN) { st1 = 'Green_packet_closed'; st2 = 'Green_packet_open'; }
        else if (type == WOTrain.CELL_RED) {   st1 = 'Red_packet_closed';   st2 = 'Red_packet_open'; }
        _imClosed = new Image(g.allData.atlas['interfaceAtlas'].getTexture(st1));
        _imOpen = new Image(g.allData.atlas['interfaceAtlas'].getTexture(st2));
        _imPlawka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_button'));
        _imClosed.x = -67;
        _imClosed.y = -133;
        _source.addChild(_imClosed);
        _imOpen.x = -67;
        _imOpen.y = -102;
        _source.addChild(_imOpen);
        _imPlawka.x = -42;
        _imPlawka.y = -23;
        _source.addChild(_imPlawka);
        _txtCount = new CTextField(62,30,'20/20');
        _txtCount.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txtCount.x = -33;
        _txtCount.y = -18;
        _source.addChild(_txtCount);
        _isHover = false;
    }

    public function fillIt(t:TrainCell, f:Function):void {
        _info = t;
        _f = f;
        if (!t) {
            Cc.error('WOTrainItem fillIt:: trainCell==null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woTrain');
            return;
        }
        _dataResource = g.allData.getResourceById(_info.id);
        if (!_dataResource) {
            Cc.error('WOTrainItem fillIt:: g.dataResource.objectResources[_info.id]==null for: ' + _info.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woTrain');
            return;
        }
//        if (int(_info.helpId) != 0) return;   ????
        _txtCount.text = String(g.userInventory.getCountResourceById(_dataResource.id)) + '/' + String(_info.count);
       _imResource = currentImage();
//        MCScaler.scale(_imResource, 80, 80);
        _imResource.alignPivot();
        _imResource.y = - 62;
        _source.addChild(_imResource);
        _source.endClickCallback = onClick;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        if (isResourceLoaded) {
            _imClosed.visible = true;
            _imOpen.visible = false;
            _txtCount.visible = false;
            _imPlawka.visible = false;
            _imResource.visible = false;
        } else {
            _imClosed.visible = false;
            _imOpen.visible = true;
            _txtCount.visible = true;
            _imPlawka.visible = true;
            _imResource.visible = true;
        }
        if (_info.needHelp && !_needHelp && int(_info.helpId) == 0) {
            _needHelp = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
            _needHelp.x = 35;
            _needHelp.y = -95;
            _source.addChild(_needHelp);
        }
    }

    public function get source():CSprite { return _source; }
    public function get idFree():int { if (_info) return _info.id;   else return 0; }
    public function get countFree():int {  if (_info) return _info.count;   else return 0; }
    public function get needHelp():Boolean { if (_info) return _info.needHelp;  else return false; }
    public function get idWhoHelp():String { if (_info) return _info.helpId;   else return ' '; }
    public function get trainDbId():String { if (_info) return _info.item_db_id;   else return ''; }
    public function get countXP():int { if (_info) return _info.countXP;  else return 0; }
    public function get countCoins():int {  if (_info) return _info.countMoney;  else return 0; }
    public function updateIt():void { if (_info && !_info.isFull) _txtCount.text = String(g.userInventory.getCountResourceById(_dataResource.id)) + '/' + String(_info.count);  }
    public function get isResourceLoaded():Boolean { if (!_info) return false;  else return _info.isFull;  }
    public function canFull():Boolean { if (!_info) return false;  else return _info.canBeFull(); }

    public function currentImage():Image {
        if (_dataResource.buildType == BuildType.PLANT) return new Image(g.allData.atlas['resourceAtlas'].getTexture(_dataResource.imageShop + '_icon'));
        else return new Image(g.allData.atlas[_dataResource.url].getTexture(_dataResource.imageShop));
    }
    
    public function onClickHelpMePls(b:Boolean = false):void {
        if (b) {
            if (!_needHelp) {
                _needHelp = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
                _needHelp.x = 35;
                _needHelp.y = -95;
                _source.addChild(_needHelp);
            }
        } else {
            if (_needHelp) {
                if (_source.contains(_needHelp)) _source.removeChild(_needHelp);
                _needHelp.dispose();
                _needHelp = null;
            }
        }
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_f != null) {
            _f.apply(null, [_index]);
        }
    }

    private function onHover():void {
        if (_isHover) return;
        _isHover = true;
        if(!_info.isFull) g.marketHint.showIt(_info.id, _source.x - _source.width/2, _source.y - _source.height, _source);
    }

    private function onOut():void {
        if (!_isHover) return;
        _isHover = false;
        g.marketHint.hideIt();
    }

    public function fullIt():void {
        _imClosed.visible = true;
        _imOpen.visible = false;
        _txtCount.visible = false;
        _imPlawka.visible = false;
        _imResource.visible = false;
        if (_needHelp) _needHelp.visible = false;
        _info.fullIt(_imResource);
    }

    public function fullItHelp():void {
        _imClosed.visible = true;
        _imOpen.visible = false;
        _txtCount.visible = false;
        _imPlawka.visible = false;
        _imResource.visible = false;
        if (_needHelp) _needHelp.visible = false;
        _info.fullIt(_imResource);
        _info.whoHelpId(String(g.user.userSocialId));
        _info.needHelpNow(false);
    }

    public function activateIt(v:Boolean):void {
        _imClosed.visible = !v;
        _imOpen.visible = v;
        _txtCount.visible = v;
        _imPlawka.visible = v;
        if (_imResource) _imResource.visible = v;
        if (v) _imClosed.filter = ManagerFilters.DISABLE_FILTER;
           else if (_imClosed.filter) _imClosed.filter.dispose();
    }
    
    public function addFilterOnClick(v:Boolean):void {
        if (v) {
            if (_imClosed.visible) _imClosed.filter = ManagerFilters.LIGHT_ORANGE_STROKE;
            if (_imOpen.visible) _imOpen.filter = ManagerFilters.LIGHT_ORANGE_STROKE;
        } else {
            if (_imClosed.filter) _imClosed.filter = null;
            if (_imOpen.filter) _imOpen.filter = null;
        }
    }

    public function updateAvatar():void {
        if (!_personBuyer || !_personBuyer.photo) _personBuyer = g.user.getSomeoneBySocialId(_info.helpId);
        if (_personBuyer.photo == '' || _personBuyer.photo == 'unknown') _personBuyer.photo = SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_personBuyer.photo, onLoadPhoto);
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) bitmap = g.pBitmaps[_personBuyer.photo].create() as Bitmap;
        if (!bitmap) { Cc.error('FriendItem:: no photo for userId: ' + _personBuyer.userSocialId);
            return; }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        if (tex) {
            _ava = new Image(tex);
            MCScaler.scale(_ava, 70, 70);
            _ava.y = -65;
            _source.addChild(_ava);
        } else {
            Cc.error('MarketItem photoFromTexture for ava:: no texture(')
        }
    }

    public function deleteIt():void {
        if (_imClosed.filter) _imClosed.filter.dispose();
        _source.removeChild(_txtCount);
        _txtCount.deleteIt();
        _source.deleteIt();
        _source = null;
        _personBuyer = null;
        _info = null;
        _dataResource = null;
    }
}
}
