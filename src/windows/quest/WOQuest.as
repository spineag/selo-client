/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import manager.ManagerFilters;
import quest.ManagerQuest;
import quest.QuestStructure;
import starling.display.Image;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOQuest extends WindowMain{
    private var _woBG:WindowBackgroundNew;
    private var _bgC:BackgroundYellowOut;
    private var _quest:QuestStructure;
    private var _txtName:CTextField;
    private var _questItem:WOQuestItem;
    private var _award:WOQuestAward;
    private var _txtDescription:CTextField;
    private var _questIcon:Image;

    public function WOQuest() {
        super();
        _windowType = WindowsManager.WO_QUEST;
        _woWidth = 520;
        _woHeight = 600;
        _woBG = new WindowBackgroundNew(_woWidth, 270, 90);
        _woBG.y = -170;
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

//        _bgC = new BackgroundYellowOut(480, 240);
//        _bgC.filter =  ManagerFilters.SHADOW;
//        _bgC.x = -240;
//        _bgC.y = 12;
//        _source.addChild(_bgC);

        _txtName = new CTextField(400, 100, '');
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtName.x = -205;
        _txtName.y = -310;
        _txtName.touchable = false;
        _source.addChild(_txtName);

        _txtDescription = new CTextField(515, 200, '');
        _txtDescription.setFormat(CTextField.BOLD30, 26, ManagerFilters.BLUE_LIGHT_NEW);
        _txtDescription.x = -260;
        _txtDescription.y = -255;
        _txtDescription.touchable = false;
        _source.addChild(_txtDescription);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _quest = params[0];
        if (!_quest.tasks.length) { Cc.error('WOQuest showItParams: no tasks for questId: ' + _quest.id); return; }
        if (!_quest.awards.length) { Cc.error('WOQuest showItParams: no awards for questId: ' + _quest.id); return; }
        if (g.managerQuest.checkQuestForDone(_quest)) return;
//        if (g.allData.atlas['questAtlas']) {
//            var im:Image;
//            im = new Image(g.allData.atlas['questAtlas'].getTexture('quest_window_back'));
//            if (im) {
//                im.x = -im.width/2;
//                im.y = -270;
//                im.touchable = false;
//                _source.addChild(im);
//            } else {
//                Cc.error('WOQuest showItParams:: no image for bg quest');
//            }
//        } else {
//            Cc.error('WOQuest showItParams:: no questAtlas');
//        }
        _txtDescription.text = _quest.description;
        if (g.user.isTester) _txtName.text = String(_quest.id) + ': ' + _quest.questName;
            else _txtName.text = _quest.questName;
        _source.setChildIndex(_txtDescription, _source.numChildren-1);
        _source.setChildIndex(_txtName, _source.numChildren-1);
        _source.setChildIndex(_btnExit, _source.numChildren-1);
        _award = new WOQuestAward(_source, _quest.awards);
        _questItem = new WOQuestItem(_source, _quest.tasks);
        super.showIt();

//        var st:String = _quest.iconPath;
//        if (st == '0') {
//            st = _quest.getUrlFromTask();
//            if (st == '0') {
//                addIm(_quest.iconImageFromAtlas());
//            } else {
//                g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
//            }
//        } else {
//            g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
//        }
        Cc.info("woQuest showItParams 7");
    }

    private function onLoadIcon(bitmap:Bitmap):void { addIm(new Image(Texture.fromBitmap(bitmap))); }
    
    private function addIm(im:Image):void {
        _questIcon = im;
        if (_questIcon) {
            MCScaler.scale(_questIcon, 188, 148);
            _questIcon.alignPivot();
            _questIcon.x = -215;
            _questIcon.y = -215;
            _source.addChild(_questIcon);
        }
    }

    override protected function deleteIt():void {
        g.managerQuest.onHideWO();
        if (_txtName) {
            _source.removeChild(_txtName);
            _txtName.deleteIt();
            _txtName = null;
        }
        if (_txtDescription) {
            _source.removeChild(_txtDescription);
            _txtDescription.deleteIt();
            _txtDescription = null;
        }
        _award.deleteIt();
        _questItem.deleteIt();
        if (_bgC) {
            _source.removeChild(_bgC);
            _bgC.deleteIt();
        }
        super.deleteIt();
    }
}
}
