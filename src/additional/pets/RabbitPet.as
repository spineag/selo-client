/**
 * Created by andy on 10/20/17.
 */
package additional.pets {
import data.StructureDataPet;

public class RabbitPet  extends PetMain {
    public function RabbitPet(dPet:StructureDataPet) {
        super(dPet);

        _animation.defaultScaleX = -1;
        _innerPosX1 = -62 * g.scaleFactor;
        _innerPosY1 = 48 * g.scaleFactor;
        _innerPosX2 = -88 * g.scaleFactor;
        _innerPosY2 = 94 * g.scaleFactor;
        _innerPosX3 = 52 * g.scaleFactor;
        _innerPosY3 = 92 * g.scaleFactor;
    }

    override protected function releaseTexture():void {
        switch (_petData.id) {
            case 5: // blue_rabbit  -> default
                _animation.changeTexture("Right_ear",          "blue_rabbit_ear_right_front", true);
                _animation.changeTexture("Left_ear",           "blue_rabbit_left_ear_front", true);
                _animation.changeTexture("head",               "blue_rabbit_head_front", true);
                _animation.changeTexture("body",               "blue_rabbit_body_front", true);
                _animation.changeTexture("hend_L",             "blue_rabbit_hand_left_front", true);
                _animation.changeTexture("leg_L",              "blue_rabbit_leg_left_front", true);
                _animation.changeTexture("hand_R",             "blue_rabbit_hand_right_front", true);
                _animation.changeTexture("leg_R",              "blue_rabbit_leg_right_front", true);
                _animation.changeTexture("tail-end",           "blue_rabbit_tail-end_front", true);
                _animation.changeTexture("cheek",              "blue_rabbit_cheek", true);
                _animation.changeTexture("cheek copy",         "blue_rabbit_cheek", true);
                _animation.changeTexture("eye01",              "blue_rabbit_eye_left_front", true);
                _animation.changeTexture("eye02",              "blue_rabbit_eye_right_front", true);
                _animation.changeTexture("closed_eye",         "blue_rabbit_close_eye_front", true);
                _animation.changeTexture("Left_ear",           "blue_rabbit_left_ear_back", true);
                _animation.changeTexture("Right_ear",          "blue_rabbit_ear_right_back", true);
                _animation.changeTexture("eye",                "blue_rabbit_eye_left_black", true);
                _animation.changeTexture("head",               "blue_rabbit_head_back", false);
                _animation.changeTexture("body",               "blue_rabbit_body_back", false);
                _animation.changeTexture("hand_L",             "blue_rabbit_hand_left_back", false);
                _animation.changeTexture("leg_R",              "blue_rabbit_leg_right_back", false);
                _animation.changeTexture("hand_R",             "blue_rabbit_hand_right_back", false);
                _animation.changeTexture("leg_L",              "blue_rabbit_leg_left_back", false);
                _animation.changeTexture("tail-end",           "blue_rabbit_tail-end_back", false);
                break;
            case 15: // violet_rabbit
                _animation.changeTexture("Right_ear",          "violet_rabbit_ear_right_front", true);
                _animation.changeTexture("Left_ear",           "violet_rabbit_ear_left_front", true);
                _animation.changeTexture("head",               "violet_rabbit_head_front", true);
                _animation.changeTexture("body",               "violet_rabbit_body_front", true);
                _animation.changeTexture("hend_L",             "violet_rabbit_hand_left_front", true);
                _animation.changeTexture("leg_L",              "violet_rabbit_leg_left_front", true);
                _animation.changeTexture("hand_R",             "violet_rabbit_hand_right_front", true);
                _animation.changeTexture("leg_R",              "violet_rabbit_leg_right_front", true);
                _animation.changeTexture("tail-end",           "violet_rabbit_tail-end_front", true);
                _animation.changeTexture("cheek",              "violet_rabbit_cheek", true);
                _animation.changeTexture("cheek copy",         "violet_rabbit_cheek", true);
                _animation.changeTexture("eye01",              "violet_rabbit_eye_front", true);
                _animation.changeTexture("eye02",              "violet_rabbit_eye_front", true);
                _animation.changeTexture("closed_eye",         "violet_rabbit_eye_close_left_front", true); //
                _animation.changeTexture("Left_ear",           "violet_rabbit_ear_left_back", false);
                _animation.changeTexture("Right_ear",          "violet_rabbit_ear_right_back",  false);
                _animation.changeTexture("eye",                "blue_rabbit_eye_left_black",  false);
                _animation.changeTexture("head",               "violet_rabbit_head_back",  false);
                _animation.changeTexture("body",               "violet_rabbit_body_back",  false);
                _animation.changeTexture("hand_L",             "violet_rabbit_hand_left_back",  false);
                _animation.changeTexture("leg_R",              "violet_rabbit_leg_left_back",  false); //
                _animation.changeTexture("hand_R",             "violet_rabbit_hand_right_back",  false);
                _animation.changeTexture("leg_L",              "violet_rabbit_leg_left_back",  false);
                _animation.changeTexture("tail-end",           "violet_rabbit_tail-end_back",  false);
                _animation.changeTexture("Layer 13",           "violet_rabbit_ear_right_front",  false);
                break;
            case 16: // orange_rabbit
                _animation.changeTexture("Right_ear",          "orange_rabbit_ear_right_front", true);
                _animation.changeTexture("Left_ear",           "orange_rabbit_left_ear_front", true);
                _animation.changeTexture("head",               "orange_rabbit_head_front", true);
                _animation.changeTexture("body",               "orange_rabbit_body_front", true);
                _animation.changeTexture("hend_L",             "orange_rabbit_hand_left_front", true);
                _animation.changeTexture("leg_L",              "orange_rabbit_leg_left_front", true);
                _animation.changeTexture("hand_R",             "orange_rabbit_hand_right_front", true);
                _animation.changeTexture("leg_R",              "orange_rabbit_leg_right_front", true);
                _animation.changeTexture("tail-end",           "orange_rabbit_tail-end_front", true);
                _animation.changeTexture("cheek",              "orange_rabbit_cheek", true);
                _animation.changeTexture("cheek copy",         "orange_rabbit_cheek", true);
                _animation.changeTexture("eye01",              "orange_rabbit_eye_left_front", true);
                _animation.changeTexture("eye02",              "orange_rabbit_eye_right_front", true);
                _animation.changeTexture("closed_eye",         "orange_rabbit_close_eye_left_front", true); //
                _animation.changeTexture("Left_ear",           "orange_rabbit_left_ear_back",  false);
                _animation.changeTexture("Right_ear",          "orange_rabbit_right_ear_back",  false);
                _animation.changeTexture("eye",                "orange_rabbit_eye_left_back",  false);
                _animation.changeTexture("head",               "orange_rabbit_head_back",  false);
                _animation.changeTexture("body",               "orange_rabbit_body_back",  false);
                _animation.changeTexture("hand_L",             "orange_rabbit_hand_left_back",  false);
                _animation.changeTexture("leg_R",              "orange_rabbit_leg_right_back",  false);
                _animation.changeTexture("hand_R",             "orange_rabbit_hand_right_back",  false);
                _animation.changeTexture("leg_L",              "orange_rabbit_leg_left_back",  false);
                _animation.changeTexture("tail-end",           "orange_rabbit_tail-end_back",  false);
                _animation.changeTexture("Layer 13",           "orange_rabbit_ear_right_front",  false);
                break;
        }
        super.releaseTexture();
    }

    public function clearIt():void {
        deleteIt();
    }
}
}
