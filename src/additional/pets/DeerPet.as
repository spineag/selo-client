/**
 * Created by andy on 10/20/17.
 */
package additional.pets {
import data.StructureDataPet;

public class DeerPet extends PetMain  {
    public function DeerPet(dPet:StructureDataPet) {
        super(dPet);

        _innerPosX1 = -20 * g.scaleFactor;
        _innerPosY1 = 50 * g.scaleFactor;
        _innerPosX2 = -118 * g.scaleFactor;
        _innerPosY2 = 96 * g.scaleFactor;
        _innerPosX3 = 90 * g.scaleFactor;
        _innerPosY3 = 96 * g.scaleFactor;
    }

    override protected function releaseTexture():void {
        switch (_petData.id) {
            case 6: // white
                changeTexture("brown_deer_horn_front.png",               "white_deer_horn_front", _armature);
                changeTexture("brown_deer_ear_left_front.png",           "white_deer_ear_left_front", _armature);
                changeTexture("brown_deer_ear_right_front.png",          "white_deer_ear_right_front", _armature);
                changeTexture("brown_deer_head_front.png",               "white_deer_head_front", _armature);
                changeTexture("brown_deer_body_front.png",               "white_deer_body_front", _armature);
                changeTexture("brown_deer_leg_first_left_front.png",     "white_deer_leg_first_left_front", _armature);
                changeTexture("brown_deer_leg_second_left_front.png",    "white_deer_leg_second_left_front", _armature);
                changeTexture("brown_deer_leg_first_right_front.png",    "white_deer_leg_first_right_front", _armature);
                changeTexture("brown_deer_leg_second_right_front.png",   "white_deer_leg_second_right_front", _armature);
                changeTexture("brown_deer_tail-end_front.png",           "white_deer_tail-end_front", _armature);
                changeTexture("cheek",                                   "white_deer_cheek", _armature);
                changeTexture("cheek copy",                              "white_deer_cheek", _armature);
                changeTexture("brown_deer_eye.png",                      "white_deer_eye", _armature);
                changeTexture("brown_deer_eye.png copy",                 "white_deer_eye", _armature);
                changeTexture("eyelids",                                 "white_deer_eyes_closed_front", _armature);
                changeTexture("brown_deer_ear_left_back.png",            "white_deer_ear_left_back", _armatureBack);
                changeTexture("brown_deer_ear_right_back.png",           "white_deer_ear_right_back", _armatureBack);
                changeTexture("brown_deer_head_back.png",                "white_deer_head_back", _armatureBack);
                changeTexture("brown_deer_body_back.png",                "white_deer_body_back", _armatureBack);
                changeTexture("brown_deer_leg_first_right_back.png",     "white_deer_leg_first_right_back", _armatureBack);
                changeTexture("brown_deer_leg_second_right_back.png",    "white_deer_leg_second_right_back", _armatureBack);
                changeTexture("brown_deer_leg_first_left_back.png",      "white_deer_leg_first_left_back", _armatureBack);
                changeTexture("brown_deer_leg_second_left_back.png",     "white_deer_leg_second_left_back", _armatureBack);
                changeTexture("brown_deer_tail-end_back.png",            "white_deer_tail-end_back", _armatureBack);
                break;
            case 17: // dark_brown
                changeTexture("brown_deer_horn_front.png",               "dark_brown_deer_horn_front", _armature);
                changeTexture("brown_deer_ear_left_front.png",           "dark_brown_deer_ear_left_front", _armature);
                changeTexture("brown_deer_ear_right_front.png",          "dark_brown_deer_ear_right_front", _armature);
                changeTexture("brown_deer_head_front.png",               "dark_brown_deer_head_front", _armature);
                changeTexture("brown_deer_body_front.png",               "dark_brown_deer_body_front", _armature);
                changeTexture("brown_deer_leg_first_left_front.png",     "dark_brown_deer_leg_first_left_front", _armature);
                changeTexture("brown_deer_leg_second_left_front.png",    "dark_brown_deer_leg_second_left_front", _armature);
                changeTexture("brown_deer_leg_first_right_front.png",    "dark_brown_deer_leg_first_right_front", _armature);
                changeTexture("brown_deer_leg_second_right_front.png",   "dark_brown_deer_leg_second_right_front", _armature);
                changeTexture("brown_deer_tail-end_front.png",           "dark_brown_deer_tail-end_front", _armature);
                changeTexture("cheek",                                   "dark_brown_deer_cheek", _armature);
                changeTexture("cheek copy",                              "dark_brown_deer_cheek", _armature);
                changeTexture("brown_deer_eye.png",                      "dark_brown_deer_eye", _armature);
                changeTexture("brown_deer_eye.png copy",                 "dark_brown_deer_eye", _armature);
                changeTexture("eyelids",                                 "dark_brown_deer_close_eyes_front", _armature);
                changeTexture("brown_deer_ear_left_back.png",            "dark_brown_deer_ear_left_back", _armatureBack);
                changeTexture("brown_deer_ear_right_back.png",           "dark_brown_deer_ear_right_back", _armatureBack);
                changeTexture("brown_deer_head_back.png",                "dark_brown_deer_head_back", _armatureBack);
                changeTexture("brown_deer_body_back.png",                "dark_brown_deer_body_back", _armatureBack);
                changeTexture("brown_deer_leg_first_right_back.png",     "dark_brown_deer_leg_first_right_back", _armatureBack);
                changeTexture("brown_deer_leg_second_right_back.png",    "dark_brown_deer_leg_second_right_back", _armatureBack);
                changeTexture("brown_deer_leg_first_left_back.png",      "dark_brown_deer_leg_first_left_back", _armatureBack);
                changeTexture("brown_deer_leg_second_left_back.png",     "dark_brown_deer_leg_second_left_back", _armatureBack);
                changeTexture("brown_deer_tail-end_back.png",            "dark_brown_deer_tail-end_back", _armatureBack);
                break;
            case 18: // milk
                changeTexture("brown_deer_horn_front.png",               "milk_deer_horn_front", _armature);
                changeTexture("brown_deer_ear_left_front.png",           "milk_deer_ear_left_front", _armature);
                changeTexture("brown_deer_ear_right_front.png",          "milk_deer_ear_right_front", _armature);
                changeTexture("brown_deer_head_front.png",               "milk_deer_head_front", _armature);
                changeTexture("brown_deer_body_front.png",               "milk_deer_body_front", _armature);
                changeTexture("brown_deer_leg_first_left_front.png",     "milk_deer_leg_first_left_front", _armature);
                changeTexture("brown_deer_leg_second_left_front.png",    "milk_deer_leg_second_left_front", _armature);
                changeTexture("brown_deer_leg_first_right_front.png",    "milk_deer_leg_first_right_front", _armature);
                changeTexture("brown_deer_leg_second_right_front.png",   "milk_deer_leg_second_right_front", _armature);
                changeTexture("brown_deer_tail-end_front.png",           "pastel_brown_tail-end_front", _armature);
                changeTexture("cheek",                                   "milk_deer_cheek", _armature);
                changeTexture("cheek copy",                              "milk_deer_cheek", _armature);
                changeTexture("brown_deer_eye.png",                      "milk_deer_eye", _armature);
                changeTexture("brown_deer_eye.png copy",                 "milk_deer_eye", _armature);
                changeTexture("eyelids",                                 "milk_deer_eyes_closed", _armature);
                changeTexture("brown_deer_ear_left_back.png",            "milk_deer_ear_left_back", _armatureBack);
                changeTexture("brown_deer_ear_right_back.png",           "milk_deer_ear_right_back", _armatureBack);
                changeTexture("brown_deer_head_back.png",                "milk_deer_head_back", _armatureBack);
                changeTexture("brown_deer_body_back.png",                "milk_deer_body_back", _armatureBack);
                changeTexture("brown_deer_leg_first_right_back.png",     "milk_deer_leg_first_right_back", _armatureBack);
                changeTexture("brown_deer_leg_second_right_back.png",    "milk_deer_leg_second_right_back", _armatureBack);
                changeTexture("brown_deer_leg_first_left_back.png",      "milk_deer_leg_first_left_back", _armatureBack);
                changeTexture("brown_deer_leg_second_left_back.png",     "milk_deer_leg_second_left_back", _armatureBack);
                changeTexture("brown_deer_tail-end_back.png",            "pastel_brown_tail-end_back", _armatureBack);
                break;
            case 19: // brown
                changeTexture("brown_deer_horn_front.png",               "brown_deer_horn_front", _armature);
                changeTexture("brown_deer_ear_left_front.png",           "brown_deer_ear_left_front", _armature);
                changeTexture("brown_deer_ear_right_front.png",          "brown_deer_ear_right_front", _armature);
                changeTexture("brown_deer_head_front.png",               "brown_deer_head_front", _armature);
                changeTexture("brown_deer_body_front.png",               "brown_deer_body_front", _armature);
                changeTexture("brown_deer_leg_first_left_front.png",     "brown_deer_leg_first_left_front", _armature);
                changeTexture("brown_deer_leg_second_left_front.png",    "brown_deer_leg_second_left_front", _armature);
                changeTexture("brown_deer_leg_first_right_front.png",    "brown_deer_leg_first_right_front", _armature);
                changeTexture("brown_deer_leg_second_right_front.png",   "brown_deer_leg_second_right_front", _armature);
                changeTexture("brown_deer_tail-end_front.png",           "brown_deer_tail-end_front", _armature);
                changeTexture("cheek",                                   "brown_deer_cheek", _armature);
                changeTexture("cheek copy",                              "brown_deer_cheek", _armature);
                changeTexture("brown_deer_eye.png",                      "brown_deer_eye", _armature);
                changeTexture("brown_deer_eye.png copy",                 "brown_deer_eye", _armature);
                changeTexture("eyelids",                                 "brown_deer_eye_closed", _armature);
                changeTexture("brown_deer_ear_left_back.png",            "brown_deer_ear_left_back", _armatureBack);
                changeTexture("brown_deer_ear_right_back.png",           "brown_deer_ear_right_back", _armatureBack);
                changeTexture("brown_deer_head_back.png",                "brown_deer_head_back", _armatureBack);
                changeTexture("brown_deer_body_back.png",                "brown_deer_body_back", _armatureBack);
                changeTexture("brown_deer_leg_first_right_back.png",     "brown_deer_leg_first_right_back", _armatureBack);
                changeTexture("brown_deer_leg_second_right_back.png",    "brown_deer_leg_second_right_back", _armatureBack);
                changeTexture("brown_deer_leg_first_left_back.png",      "brown_deer_leg_first_left_back", _armatureBack);
                changeTexture("brown_deer_leg_second_left_back.png",     "brown_deer_leg_second_left_back", _armatureBack);
                changeTexture("brown_deer_tail-end_back.png",            "brown_deer_tail-end_back", _armatureBack);
                break;
            case 20: // pastel_brown
                changeTexture("brown_deer_horn_front.png",               "pastel_brown_deer_horn_front", _armature);
                changeTexture("brown_deer_ear_left_front.png",           "pastel_brown_deer_ear_left_front", _armature);
                changeTexture("brown_deer_ear_right_front.png",          "pastel_brown_deer_ear_right_front", _armature);
                changeTexture("brown_deer_head_front.png",               "pastel_brown_deer_head_front", _armature);
                changeTexture("brown_deer_body_front.png",               "pastel_brown_deer_body_front", _armature);
                changeTexture("brown_deer_leg_first_left_front.png",     "pastel_brown_deer_leg_first_left_front", _armature);
                changeTexture("brown_deer_leg_second_left_front.png",    "pastel_brown_deer_leg_second_left_front", _armature);
                changeTexture("brown_deer_leg_first_right_front.png",    "pastel_brown_deer_leg_first_right_front", _armature);
                changeTexture("brown_deer_leg_second_right_front.png",   "pastel_brown_deer_leg_second_right_front", _armature);
                changeTexture("brown_deer_tail-end_front.png",           "pastel_brown_deer_tail-end_front", _armature);
                changeTexture("cheek",                                   "pastel_brown_deer_cheek", _armature);
                changeTexture("cheek copy",                              "pastel_brown_deer_cheek", _armature);
                changeTexture("brown_deer_eye.png",                      "pastel_brown_eye", _armature);
                changeTexture("brown_deer_eye.png copy",                 "pastel_brown_eye", _armature);
                changeTexture("eyelids",                                 "pastel_brown_deer_eyes_closed", _armature);
                changeTexture("brown_deer_ear_left_back.png",            "pastel_brown_deer_ear_left_back", _armatureBack);
                changeTexture("brown_deer_ear_right_back.png",           "pastel_brown_deer_ear_right_back", _armatureBack);
                changeTexture("brown_deer_head_back.png",                "pastel_brown_deer_head_back", _armatureBack);
                changeTexture("brown_deer_body_back.png",                "pastel_brown_deer_body_back", _armatureBack);
                changeTexture("brown_deer_leg_first_right_back.png",     "pastel_brown_deer_leg_first_right_back", _armatureBack);
                changeTexture("brown_deer_leg_second_right_back.png",    "pastel_brown_deer_leg_second_right_back", _armatureBack);
                changeTexture("brown_deer_leg_first_left_back.png",      "pastel_brown_deer_leg_first_left_back", _armatureBack);
                changeTexture("brown_deer_leg_second_left_back.png",     "pastel_brown_deer_leg_second_left_back", _armatureBack);
                changeTexture("brown_deer_tail-end_back.png",            "pastel_brown_deer_tail-end_back", _armatureBack);
                break;
        }
        super.releaseTexture();
    }

    public function clearIt():void {
        deleteIt();
    }
}
}
