/**
 * Created by andy on 10/20/17.
 */
package additional.pets {
import data.StructureDataPet;

public class RabbitPet  extends PetMain {
    public function RabbitPet(dPet:StructureDataPet) {
        super(dPet);
    }

    override protected function releaseTexture():void {
        switch (_petData.id) {
            case 5: // blue_rabbit
                changeTexture("Right_ear",          "blue_rabbit_ear_right_front", _armature);
                changeTexture("Left_ear",           "blue_rabbit_left_ear_front", _armature);
                changeTexture("head",               "blue_rabbit_head_front", _armature);
                changeTexture("body",               "blue_rabbit_body_front", _armature);
                changeTexture("hend_L",             "blue_rabbit_hand_left_front", _armature);
                changeTexture("leg_L",              "blue_rabbit_leg_left_front", _armature);
                changeTexture("hand_R",             "blue_rabbit_hand_right_front", _armature);
                changeTexture("leg_R",              "blue_rabbit_leg_right_front", _armature);
                changeTexture("tail-end",           "blue_rabbit_tail-end_front.png", _armature);
                changeTexture("cheek",              "blue_rabbit_cheek", _armature);
                changeTexture("cheek copy",         "blue_rabbit_cheek", _armature);
                changeTexture("eye01",              "blue_rabbit_eye_left_front", _armature);
                changeTexture("eye02",              "blue_rabbit_eye_right_front", _armature);
                changeTexture("closed_eye",         "blue_rabbit_close_eye_front", _armature);
                changeTexture("Left_ear",           "blue_rabbit_left_ear_back", _armature);
                changeTexture("Right_ear",          "blue_rabbit_ear_right_back", _armature);
                changeTexture("eye",                "blue_rabbit_eye_left_black", _armature);
                changeTexture("head",               "blue_rabbit_head_back", _armatureBack);
                changeTexture("body",               "blue_rabbit_body_back", _armatureBack);
                changeTexture("hand_L",             "blue_rabbit_hand_left_back", _armatureBack);
                changeTexture("leg_R",              "blue_rabbit_leg_right_back", _armatureBack);
                changeTexture("hand_R",             "blue_rabbit_hand_right_back", _armatureBack);
                changeTexture("leg_L",              "blue_rabbit_leg_left_back", _armatureBack);
                changeTexture("tail-end",           "blue_rabbit_tail-end_back", _armatureBack);
                break;
            case 15: // violet_rabbit
                changeTexture("Right_ear",          "violet_rabbit_ear_right_front", _armature);
                changeTexture("Left_ear",           "violet_rabbit_left_ear_front", _armature);
                changeTexture("head",               "violet_rabbit_head_front", _armature);
                changeTexture("body",               "violet_rabbit_body_front", _armature);
                changeTexture("hend_L",             "violet_rabbit_hand_left_front", _armature);
                changeTexture("leg_L",              "violet_rabbit_leg_left_front", _armature);
                changeTexture("hand_R",             "violet_rabbit_hand_right_front", _armature);
                changeTexture("leg_R",              "violet_rabbit_leg_right_front", _armature);
                changeTexture("tail-end",           "violet_rabbit_tail-end_front.png", _armature);
                changeTexture("cheek",              "violet_rabbit_cheek", _armature);
                changeTexture("cheek copy",         "violet_rabbit_cheek", _armature);
                changeTexture("eye01",              "violet_rabbit_eye_left_front", _armature);
                changeTexture("eye02",              "violet_rabbit_eye_right_front", _armature);
                changeTexture("closed_eye",         "violet_rabbit_close_eye_front", _armature);
                changeTexture("Left_ear",           "violet_rabbit_left_ear_back", _armature);
                changeTexture("Right_ear",          "violet_rabbit_ear_right_back", _armature);
                changeTexture("eye",                "blue_rabbit_eye_left_black", _armature);
                changeTexture("head",               "violet_rabbit_head_back", _armatureBack);
                changeTexture("body",               "violet_rabbit_body_back", _armatureBack);
                changeTexture("hand_L",             "violet_rabbit_hand_left_back", _armatureBack);
                changeTexture("leg_R",              "violet_rabbit_leg_right_back", _armatureBack);
                changeTexture("hand_R",             "violet_rabbit_hand_right_back", _armatureBack);
                changeTexture("leg_L",              "violet_rabbit_leg_left_back", _armatureBack);
                changeTexture("tail-end",           "violet_rabbit_tail-end_back", _armatureBack);
                break;
            case 16: // orange_rabbit
                changeTexture("Right_ear",          "orange_rabbit_ear_right_front", _armature);
                changeTexture("Left_ear",           "orange_rabbit_left_ear_front", _armature);
                changeTexture("head",               "orange_rabbit_head_front", _armature);
                changeTexture("body",               "orange_rabbit_body_front", _armature);
                changeTexture("hend_L",             "orange_rabbit_hand_left_front", _armature);
                changeTexture("leg_L",              "orange_rabbit_leg_left_front", _armature);
                changeTexture("hand_R",             "orange_rabbit_hand_right_front", _armature);
                changeTexture("leg_R",              "orange_rabbit_leg_right_front", _armature);
                changeTexture("tail-end",           "orange_rabbit_tail-end_front.png", _armature);
                changeTexture("cheek",              "orange_rabbit_cheek", _armature);
                changeTexture("cheek copy",         "orange_rabbit_cheek", _armature);
                changeTexture("eye01",              "orange_rabbit_eye_left_front", _armature);
                changeTexture("eye02",              "orange_rabbit_eye_right_front", _armature);
                changeTexture("closed_eye",         "orange_rabbit_close_eye_front", _armature);
                changeTexture("Left_ear",           "orange_rabbit_left_ear_back", _armature);
                changeTexture("Right_ear",          "orange_rabbit_ear_right_back", _armature);
                changeTexture("eye",                "orange_rabbit_eye_left_black", _armature);
                changeTexture("head",               "orange_rabbit_head_back", _armatureBack);
                changeTexture("body",               "orange_rabbit_body_back", _armatureBack);
                changeTexture("hand_L",             "orange_rabbit_hand_left_back", _armatureBack);
                changeTexture("leg_R",              "orange_rabbit_leg_right_back", _armatureBack);
                changeTexture("hand_R",             "orange_rabbit_hand_right_back", _armatureBack);
                changeTexture("leg_L",              "orange_rabbit_leg_left_back", _armatureBack);
                changeTexture("tail-end",           "orange_rabbit_tail-end_back", _armatureBack);
                break;
        }
        super.releaseTexture();
    }
}
}
