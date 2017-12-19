/**
 * Created by user on 2/10/17.
 */
package windows.partyWindow {
import data.BuildType;
import data.DataMoney;
import flash.display.Bitmap;
import flash.geom.Point;
import manager.ManagerFilters;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import windows.WindowMain;

public class WOPartyWindowClose extends WindowMain{
    private var _txtResource:CTextField;
    private var _txtText:CTextField;
    private var _txtTextNagrada:CTextField;
    private var _txtBtn:CTextField;
    private var _btnClose:CButton;

    public function WOPartyWindowClose() {
        _woHeight = 451;
        _woWidth = 695;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/end_event_picnic_window.png',onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'qui/end_event_picnic_window.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var image:Image = new Image(tex);
        image.pivotX = image.width/2;
        image.pivotY = image.height/2;
        _source.addChild(image);
        createExitButton(hideIt);
        _txtResource = new CTextField(701, 172, 'Вы собрали ' + g.managerParty.userParty.countResource + ' зефира.');
        _txtResource.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR , Color.WHITE);
//        _txtResource.alignH = Align.LEFT;
        _txtResource.x = -350;
        _txtResource.y = -115;
        _source.addChild(_txtResource);
        _txtText = new CTextField(701, 172, 'Событие "Майский Пикник" завершено.');
        _txtText.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR , Color.WHITE);
//        _txtText.alignH = Align.LEFT;
        _txtText.x = -350;
        _txtText.y = -150;
        _source.addChild(_txtText);

        _txtTextNagrada = new CTextField(701, 172, 'Награда была начислена!');
        _txtTextNagrada.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR , Color.WHITE);
//        _txtTextNagrada.alignH = Align.LEFT;
        _txtTextNagrada.x = -350;
        _txtTextNagrada.y = -80;
        _source.addChild(_txtTextNagrada);
//        var _quad:Quad = new Quad(3.2, 3, 0xfbaaa7);
//        _quad.x = 75;
//        _quad.y = 40;
//        _source.addChild(_quad);
        _btnClose = new CButton();
        _btnClose.addButtonTexture(172, 45, CButton.GREEN, true);
        _txtBtn = new CTextField(172, 45, "ОК");
        _txtBtn.setFormat(CTextField.BOLD18, 18,Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btnClose.addChild(_txtBtn);
        _btnClose.clickCallback = hideIt;
        _btnClose.y = 200;
        _source.addChild(_btnClose);
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    override public function hideIt():void {
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        var d:DropObject = new DropObject();
        for (var i:int = 0; i < g.managerParty.userParty.tookGift.length; i++) {
            if (!g.managerParty.userParty.tookGift[i] && g.managerParty.userParty.countResource >= g.managerParty.countToGift[i] ) {
                if (g.managerParty.typeGift[i] == BuildType.DECOR_ANIMATION || g.managerParty.typeGift[i] == BuildType.DECOR) 
                    d.addDropDecor(g.allData.getBuildingById( g.managerParty.idGift[i]), p, g.managerParty.countGift[i]);
                else {
                    if (g.managerParty.idGift[i] == 1 && g.managerParty.typeGift[i] == 1) 
                        d.addDropMoney(DataMoney.SOFT_CURRENCY, g.managerParty.countGift[i], p);
                    else if (g.managerParty.idGift[i] == 2 && g.managerParty.typeGift[i] == 2) 
                        d.addDropMoney(DataMoney.HARD_CURRENCY, g.managerParty.countGift[i], p);
                    else d.addDropItemNewByResourceId(g.managerParty.idGift[i], p, g.managerParty.countGift[i]);
                }
            }
        }
        d.releaseIt(null, false);
        super.hideIt();
    }
}
}
