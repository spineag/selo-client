/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.StructureDataAnimal;
import data.StructureDataBuilding;
import data.StructureDataResource;

import manager.ManagerFilters;
import manager.Vars;

import mouse.BuildMoveGridTile;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class WOLevelUpItem {
    public var source:Sprite;
    private var _sourceItem:CSprite;
    private var _imNew:Image;
    private var _txtName:CTextField;
    private var _image:Image;
    private var _imageBg:Image;
    private var _data:Object;
    private var _onHover:Boolean;
    private var _bolHouse:Boolean;
    private var _bolAnimal:Boolean;
    private var g:Vars = Vars.getInstance();

    public function WOLevelUpItem(ob:Object, boNew:Boolean, boCount:Boolean, count:int = 0, wallNew:Boolean = false) {
        if (!ob) {
            Cc.error('WOLevelUpItem:: ob == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woLevelUpItem');
            return;
        }
        var obj:Object;
        var id:String;
        _data = ob;
        source = new CSprite();
        _onHover = false;
        _bolAnimal = false;
        _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture("shop_blue_cell"));
        _imageBg.x = 50 - _imageBg.width/2;
        _imageBg.y = 60 - _imageBg.height/2;
        source.addChild(_imageBg);
        _sourceItem = new CSprite();
        source.addChild(_sourceItem);
        _sourceItem.hoverCallback = onHover;
        _sourceItem.outCallback = onOut;
        _imNew = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
        _imNew.x = 95;
        _imNew.y = -50;
        source.addChild(_imNew);
//        try {
            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && !(ob is StructureDataAnimal) && ob.coins) {
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                g.userInventory.addMoney(2,ob.countSoft);
            }
            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && !(ob is StructureDataAnimal) && ob.hard) {
                _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                g.userInventory.addMoney(1,ob.countHard);
            }

            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && !(ob is StructureDataAnimal) && ob.decorData) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(ob.id).image + '_icon'));
                if (!_image) {
                    _image = new Image(g.allData.atlas[g.allData.getBuildingById(ob.id).url].getTexture(g.allData.getBuildingById(ob.id).image));
                }
                _bolHouse = true;
                var f1:Function = function (dbId:int):void {
                    g.userInventory.addToDecorInventory(ob.id, dbId);
                };
                g.server.buyAndAddToInventory(ob.id, f1);
            }


            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && !(ob is StructureDataAnimal) && ob.resourceData) {
                if (g.allData.getResourceById(ob.id).buildType == BuildType.PLANT) {
                    _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(ob.id).imageShop + '_icon'));
                } else {
                    _image = new Image(g.allData.atlas[g.allData.getResourceById(ob.id).url].getTexture(g.allData.getResourceById(ob.id).imageShop));
                }
                g.userInventory.addResource(ob.id,ob.count);
            }

            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && !(ob is StructureDataAnimal) && ob.catCount) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
                _data.id = -1;
            }
            if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && !(ob is StructureDataAnimal) && ob.ridge) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture('ridge_icon'));
                _data.id = 11;
                _data.name = g.allData.getBuildingById(11).name;
            }
            if (ob.buildType == BuildType.FARM) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.RIDGE) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.FABRICA) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.TREE) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.RESOURCE) {
                _image = new Image(g.allData.atlas[ob.url].getTexture(ob.imageShop));
            } else if (ob.buildType == BuildType.PLANT) {
                _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(ob.imageShop + '_icon'));
            } else if (ob.buildType == BuildType.DECOR_FULL_FENСE || ob.buildType == BuildType.DECOR_POST_FENCE || ob.buildType == BuildType.DECOR_POST_FENCE_ARKA 
                    || ob.buildType == BuildType.DECOR_TAIL || ob.buildType == BuildType.DECOR || ob.buildType == BuildType.DECOR_FENCE_ARKA) {
                if (ob.image) {
                    var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon');
                    if (!texture) {
                        texture = g.allData.atlas[_data.url].getTexture(_data.image);
                    }
                }
                _image = new Image(texture);
                _bolHouse = true;
            } else if (ob.buildType == BuildType.ANIMAL) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.url + '_icon'));
                _bolHouse = true;
                _bolAnimal = true;
            } else if (ob.buildType == BuildType.INSTRUMENT) {
                _image = new Image(g.allData.atlas[ob.url].getTexture(ob.imageShop));
            } else if (ob.buildType == BuildType.MARKET || ob.buildType == BuildType.PAPER || ob.buildType == BuildType.TRAIN) {
                 _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.image + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.CAVE) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(ob.url + '_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.DAILY_BONUS) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture('daily_bonus_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.ORDER) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture('orders_icon'));
                _bolHouse = true;
            } else if (ob.buildType == BuildType.DECOR_ANIMATION) {
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon'));
                _bolHouse = true;
            }
//        } catch (e:Error) {
//          Cc.error('WOLevelUpItem:: error with _image for data.id: ' + ob.id);
//       }
        _txtName = new CTextField(160, 50,String(_data.name));
        _txtName.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtName.x = -32;
        _txtName.y = -50;
        source.addChild(_txtName);

        if (_image) {
            _image.x = 50 - _image.width / 2;
            _image.y = 80 - _image.height / 2;
            _sourceItem.addChild(_image);
        } else {
            Cc.error('WOLevelUpItem:: no such image: ' + count);
        }
    }

    public function deleteIt():void {
        _sourceItem.deleteIt();
        _image = null;
        _imageBg = null;
        source = null;
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        if (_data.buildType == BuildType.FARM || _data.buildType == BuildType.RIDGE || _data.buildType == BuildType.FABRICA || _data.buildType == BuildType.TREE
            || _data.buildType == BuildType.RESOURCE || _data.buildType == BuildType.PLANT || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_POST_FENCE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA
            || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FENCE_ARKA || _data.buildType == BuildType.ANIMAL
            || _data.buildType == BuildType.INSTRUMENT || _data.buildType == BuildType.MARKET || _data.buildType == BuildType.PAPER || _data.buildType == BuildType.TRAIN
            || _data.buildType == BuildType.CAVE || _data.buildType == BuildType.DAILY_BONUS || _data.buildType == BuildType.ORDER || _data.buildType == BuildType.DECOR_ANIMATION) g.levelUpHint.showIt(_data,source.x-30,source.y-50,source);
    }

    private function onOut():void {
        g.levelUpHint.hideIt();
        _onHover = false;
    }
}
}