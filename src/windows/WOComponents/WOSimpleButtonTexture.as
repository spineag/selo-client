/**
 * Created by andy on 1/21/16.
 */
package windows.WOComponents {
import com.junkbyte.console.Cc;
import flash.geom.Rectangle;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;
import utils.CButton;
import utils.DrawToBitmap;

public class WOSimpleButtonTexture  extends Sprite {
    private var g:Vars = Vars.getInstance();

    public function WOSimpleButtonTexture(w:int, h:int, _type:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var imLeft:String;
        var imCenter:String;
        var dX:int = 0;
        var dY:int = 0;
        var dW:int;
        var s:Sprite = new Sprite();

        if (w%2) w++;
        if (h!=CButton.HEIGHT_32 && h!=CButton.HEIGHT_41 && h!=CButton.HEIGHT_55) {
            Cc.error('For buttons WOSimpleButtonTexture use only HEIGHT = {SMALL=32, MEDIUM=41 or BIG=55}');
            if (h<35) h = CButton.HEIGHT_32;
            else if (h<44) h = CButton.HEIGHT_41;
            else h=CButton.HEIGHT_55;
        }

        if (h == CButton.HEIGHT_32) {
            switch (_type) {
                case CButton.GREEN: imLeft = 'green_button_s_L'; imCenter = 'green_button_s_C'; break;
                case CButton.RED: imLeft = 'red_button_s_L'; imCenter = 'red_button_s_C'; break;
                case CButton.ORANGE: imLeft = 'yellow_button_s_L'; imCenter = 'yellow_button_s_C'; break;
                case CButton.YELLOW: imLeft = 'yellow_light_button_s_L'; imCenter = 'yellow_light_button_s_C'; break;
                case CButton.BLUE: imLeft = 'blue_button_s_L'; imCenter = 'blue_button_s_C'; break;
            }
            dX = -1;
            dY = -1;
        } else if (h == CButton.HEIGHT_41) {
            switch (_type) {
                case CButton.GREEN: imLeft = 'green_button_m_L'; imCenter = 'green_button_m_C'; break;
                case CButton.RED: imLeft = 'red_button_m_L'; imCenter = 'red_button_m_C'; break;
                case CButton.ORANGE: imLeft = 'yellow_button_m_L'; imCenter = 'yellow_button_m_C'; break;
                case CButton.YELLOW: imLeft = 'yellow_light_button_m_L'; imCenter = 'yellow_light_button_m_C'; break;
                case CButton.BLUE: imLeft = 'blue_button_m_L'; imCenter = 'blue_button_m_C'; break;
            }
            dX = -5;
            dY = -6;
        } else if (h == CButton.HEIGHT_55) {
            switch (_type) {
                case CButton.GREEN: imLeft = 'green_button_b_L'; imCenter = 'green_button_b_C'; break;
                case CButton.RED: imLeft = 'red_button_b_L'; imCenter = 'red_button_b_C'; break;
                case CButton.ORANGE: imLeft = 'yellow_button_b_L'; imCenter = 'yellow_button_b_C'; break;
                case CButton.YELLOW: imLeft = 'yellow_light_button_b_L'; imCenter = 'yellow_light_button_b_C'; break;
                case CButton.BLUE: imLeft = 'blue_button_b_L'; imCenter = 'blue_button_b_C'; break;
            }
            dX = -5;
            dY = -7;
        }

        //left
        im = new Image(tex.getTexture(imLeft));
        im.x = dX;
        im.y = dY;
        dW = im.width + dX;
        s.addChild(im);

        //right
        im = new Image(tex.getTexture(imLeft));
        im.scaleX = -1;
        im.x = w - dX;
        im.y = dY;
        s.addChild(im);

        //center
        im = new Image(tex.getTexture(imCenter));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * dW;
        im.x = dW;
        im.y = dY;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        var sp2:Sprite = new Sprite();
        s.x = -dX;
        s.y = -dY;
        sp2.addChild(s);
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(sp2));
        sp2.dispose();
        im.x = dX;
        im.y = dY;
        addChild(im);
    }

    public function deleteIt():void { dispose(); }
}
}
