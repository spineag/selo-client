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
                _animation.changeTexture("brown_deer_horn_front.png",               "white_deer_horn_front", true);
                _animation.changeTexture("brown_deer_ear_left_front.png",           "white_deer_ear_left_front", true);
                _animation.changeTexture("brown_deer_ear_right_front.png",          "white_deer_ear_right_front", true);
                _animation.changeTexture("brown_deer_head_front.png",               "white_deer_head_front", true);
                _animation.changeTexture("brown_deer_body_front.png",               "white_deer_body_front", true);
                _animation.changeTexture("brown_deer_leg_first_left_front.png",     "white_deer_leg_first_left_front", true);
                _animation.changeTexture("brown_deer_leg_second_left_front.png",    "white_deer_leg_second_left_front", true);
                _animation.changeTexture("brown_deer_leg_first_right_front.png",    "white_deer_leg_first_right_front", true);
                _animation.changeTexture("brown_deer_leg_second_right_front.png",   "white_deer_leg_second_right_front", true);
                _animation.changeTexture("brown_deer_tail-end_front.png",           "white_deer_tail-end_front", true);
                _animation.changeTexture("cheek",                                   "white_deer_cheek", true);
                _animation.changeTexture("cheek copy",                              "white_deer_cheek", true);
                _animation.changeTexture("brown_deer_eye.png",                      "white_deer_eye", true);
                _animation.changeTexture("brown_deer_eye.png copy",                 "white_deer_eye", true);
                _animation.changeTexture("eyelids",                                 "white_deer_eyes_closed_front", true);
                _animation.changeTexture("brown_deer_ear_left_back.png",            "white_deer_ear_left_back", false);
                _animation.changeTexture("brown_deer_ear_right_back.png",           "white_deer_ear_right_back", false);
                _animation.changeTexture("brown_deer_head_back.png",                "white_deer_head_back", false);
                _animation.changeTexture("brown_deer_body_back.png",                "white_deer_body_back", false);
                _animation.changeTexture("brown_deer_leg_first_right_back.png",     "white_deer_leg_first_right_back", false);
                _animation.changeTexture("brown_deer_leg_second_right_back.png",    "white_deer_leg_second_right_back", false);
                _animation.changeTexture("brown_deer_leg_first_left_back.png",      "white_deer_leg_first_left_back", false);
                _animation.changeTexture("brown_deer_leg_second_left_back.png",     "white_deer_leg_second_left_back", false);
                _animation.changeTexture("brown_deer_tail-end_back.png",            "white_deer_tail-end_back", false);
                break;
            case 17: // dark_brown
                _animation.changeTexture("brown_deer_horn_front.png",               "dark_brown_deer_horn_front", true);
                _animation.changeTexture("brown_deer_ear_left_front.png",           "dark_brown_deer_ear_left_front", true);
                _animation.changeTexture("brown_deer_ear_right_front.png",          "dark_brown_deer_ear_right_front", true);
                _animation.changeTexture("brown_deer_head_front.png",               "dark_brown_deer_head_front", true);
                _animation.changeTexture("brown_deer_body_front.png",               "dark_brown_deer_body_front", true);
                _animation.changeTexture("brown_deer_leg_first_left_front.png",     "dark_brown_deer_leg_first_left_front", true);
                _animation.changeTexture("brown_deer_leg_second_left_front.png",    "dark_brown_deer_leg_second_left_front", true);
                _animation.changeTexture("brown_deer_leg_first_right_front.png",    "dark_brown_deer_leg_first_right_front", true);
                _animation.changeTexture("brown_deer_leg_second_right_front.png",   "dark_brown_deer_leg_second_right_front", true);
                _animation.changeTexture("brown_deer_tail-end_front.png",           "dark_brown_deer_tail-end_front", true);
                _animation.changeTexture("cheek",                                   "dark_brown_deer_cheek", true);
                _animation.changeTexture("cheek copy",                              "dark_brown_deer_cheek", true);
                _animation.changeTexture("brown_deer_eye.png",                      "dark_brown_deer_eye", true);
                _animation.changeTexture("brown_deer_eye.png copy",                 "dark_brown_deer_eye", true);
                _animation.changeTexture("eyelids",                                 "dark_brown_deer_close_eyes_front", true);
                _animation.changeTexture("brown_deer_ear_left_back.png",            "dark_brown_deer_ear_left_back", false);
                _animation.changeTexture("brown_deer_ear_right_back.png",           "dark_brown_deer_ear_right_back", false);
                _animation.changeTexture("brown_deer_head_back.png",                "dark_brown_deer_head_back", false);
                _animation.changeTexture("brown_deer_body_back.png",                "dark_brown_deer_body_back", false);
                _animation.changeTexture("brown_deer_leg_first_right_back.png",     "dark_brown_deer_leg_first_right_back", false);
                _animation.changeTexture("brown_deer_leg_second_right_back.png",    "dark_brown_deer_leg_second_right_back", false);
                _animation.changeTexture("brown_deer_leg_first_left_back.png",      "dark_brown_deer_leg_first_left_back", false);
                _animation.changeTexture("brown_deer_leg_second_left_back.png",     "dark_brown_deer_leg_second_left_back", false);
                _animation.changeTexture("brown_deer_tail-end_back.png",            "dark_brown_deer_tail-end_back", false);
                break;
            case 18: // milk
                _animation.changeTexture("brown_deer_horn_front.png",               "milk_deer_horn_front", true);
                _animation.changeTexture("brown_deer_ear_left_front.png",           "milk_deer_ear_left_front", true);
                _animation.changeTexture("brown_deer_ear_right_front.png",          "milk_deer_ear_right_front", true);
                _animation.changeTexture("brown_deer_head_front.png",               "milk_deer_head_front", true);
                _animation.changeTexture("brown_deer_body_front.png",               "milk_deer_body_front", true);
                _animation.changeTexture("brown_deer_leg_first_left_front.png",     "milk_deer_leg_first_left_front", true);
                _animation.changeTexture("brown_deer_leg_second_left_front.png",    "milk_deer_leg_second_left_front", true);
                _animation.changeTexture("brown_deer_leg_first_right_front.png",    "milk_deer_leg_first_right_front", true);
                _animation.changeTexture("brown_deer_leg_second_right_front.png",   "milk_deer_leg_second_right_front", true);
                _animation.changeTexture("brown_deer_tail-end_front.png",           "pastel_brown_tail-end_front", true);
                _animation.changeTexture("cheek",                                   "milk_deer_cheek", true);
                _animation.changeTexture("cheek copy",                              "milk_deer_cheek", true);
                _animation.changeTexture("brown_deer_eye.png",                      "milk_deer_eye", true);
                _animation.changeTexture("brown_deer_eye.png copy",                 "milk_deer_eye", true);
                _animation.changeTexture("eyelids",                                 "milk_deer_eyes_closed", true);
                _animation.changeTexture("brown_deer_ear_left_back.png",            "milk_deer_ear_left_back", false);
                _animation.changeTexture("brown_deer_ear_right_back.png",           "milk_deer_ear_right_back", false);
                _animation.changeTexture("brown_deer_head_back.png",                "milk_deer_head_back", false);
                _animation.changeTexture("brown_deer_body_back.png",                "milk_deer_body_back", false);
                _animation.changeTexture("brown_deer_leg_first_right_back.png",     "milk_deer_leg_first_right_back", false);
                _animation.changeTexture("brown_deer_leg_second_right_back.png",    "milk_deer_leg_second_right_back", false);
                _animation.changeTexture("brown_deer_leg_first_left_back.png",      "milk_deer_leg_first_left_back", false);
                _animation.changeTexture("brown_deer_leg_second_left_back.png",     "milk_deer_leg_second_left_back", false);
                _animation.changeTexture("brown_deer_tail-end_back.png",            "pastel_brown_tail-end_back", false);
                break;
            case 19: // brown
                _animation.changeTexture("brown_deer_horn_front.png",               "brown_deer_horn_front", true);
                _animation.changeTexture("brown_deer_ear_left_front.png",           "brown_deer_ear_left_front", true);
                _animation.changeTexture("brown_deer_ear_right_front.png",          "brown_deer_ear_right_front", true);
                _animation.changeTexture("brown_deer_head_front.png",               "brown_deer_head_front", true);
                _animation.changeTexture("brown_deer_body_front.png",               "brown_deer_body_front", true);
                _animation.changeTexture("brown_deer_leg_first_left_front.png",     "brown_deer_leg_first_left_front", true);
                _animation.changeTexture("brown_deer_leg_second_left_front.png",    "brown_deer_leg_second_left_front", true);
                _animation.changeTexture("brown_deer_leg_first_right_front.png",    "brown_deer_leg_first_right_front", true);
                _animation.changeTexture("brown_deer_leg_second_right_front.png",   "brown_deer_leg_second_right_front", true);
                _animation.changeTexture("brown_deer_tail-end_front.png",           "brown_deer_tail-end_front", true);
                _animation.changeTexture("cheek",                                   "brown_deer_cheek", true);
                _animation.changeTexture("cheek copy",                              "brown_deer_cheek", true);
                _animation.changeTexture("brown_deer_eye.png",                      "brown_deer_eye", true);
                _animation.changeTexture("brown_deer_eye.png copy",                 "brown_deer_eye", true);
                _animation.changeTexture("eyelids",                                 "brown_deer_eye_closed", true);
                _animation.changeTexture("brown_deer_ear_left_back.png",            "brown_deer_ear_left_back", false);
                _animation.changeTexture("brown_deer_ear_right_back.png",           "brown_deer_ear_right_back", false);
                _animation.changeTexture("brown_deer_head_back.png",                "brown_deer_head_back", false);
                _animation.changeTexture("brown_deer_body_back.png",                "brown_deer_body_back", false);
                _animation.changeTexture("brown_deer_leg_first_right_back.png",     "brown_deer_leg_first_right_back", false);
                _animation.changeTexture("brown_deer_leg_second_right_back.png",    "brown_deer_leg_second_right_back", false);
                _animation.changeTexture("brown_deer_leg_first_left_back.png",      "brown_deer_leg_first_left_back", false);
                _animation.changeTexture("brown_deer_leg_second_left_back.png",     "brown_deer_leg_second_left_back", false);
                _animation.changeTexture("brown_deer_tail-end_back.png",            "brown_deer_tail-end_back", false);
                break;
            case 20: // pastel_brown
                _animation.changeTexture("brown_deer_horn_front.png",               "pastel_brown_deer_horn_front", true);
                _animation.changeTexture("brown_deer_ear_left_front.png",           "pastel_brown_deer_ear_left_front", true);
                _animation.changeTexture("brown_deer_ear_right_front.png",          "pastel_brown_deer_ear_right_front", true);
                _animation.changeTexture("brown_deer_head_front.png",               "pastel_brown_deer_head_front", true);
                _animation.changeTexture("brown_deer_body_front.png",               "pastel_brown_deer_body_front", true);
                _animation.changeTexture("brown_deer_leg_first_left_front.png",     "pastel_brown_deer_leg_first_left_front", true);
                _animation.changeTexture("brown_deer_leg_second_left_front.png",    "pastel_brown_deer_leg_second_left_front", true);
                _animation.changeTexture("brown_deer_leg_first_right_front.png",    "pastel_brown_deer_leg_first_right_front", true);
                _animation.changeTexture("brown_deer_leg_second_right_front.png",   "pastel_brown_deer_leg_second_right_front", true);
                _animation.changeTexture("brown_deer_tail-end_front.png",           "pastel_brown_deer_tail-end_front", true);
                _animation.changeTexture("cheek",                                   "pastel_brown_deer_cheek", true);
                _animation.changeTexture("cheek copy",                              "pastel_brown_deer_cheek", true);
                _animation.changeTexture("brown_deer_eye.png",                      "pastel_brown_eye", true);
                _animation.changeTexture("brown_deer_eye.png copy",                 "pastel_brown_eye", true);
                _animation.changeTexture("eyelids",                                 "pastel_brown_deer_eyes_closed", true);
                _animation.changeTexture("brown_deer_ear_left_back.png",            "pastel_brown_deer_ear_left_back", false);
                _animation.changeTexture("brown_deer_ear_right_back.png",           "pastel_brown_deer_ear_right_back", false);
                _animation.changeTexture("brown_deer_head_back.png",                "pastel_brown_deer_head_back", false);
                _animation.changeTexture("brown_deer_body_back.png",                "pastel_brown_deer_body_back", false);
                _animation.changeTexture("brown_deer_leg_first_right_back.png",     "pastel_brown_deer_leg_first_right_back", false);
                _animation.changeTexture("brown_deer_leg_second_right_back.png",    "pastel_brown_deer_leg_second_right_back", false);
                _animation.changeTexture("brown_deer_leg_first_left_back.png",      "pastel_brown_deer_leg_first_left_back", false);
                _animation.changeTexture("brown_deer_leg_second_left_back.png",     "pastel_brown_deer_leg_second_left_back", false);
                _animation.changeTexture("brown_deer_tail-end_back.png",            "pastel_brown_deer_tail-end_back", false);
                break;
        }
        super.releaseTexture();
    }

    public function clearIt():void {
        deleteIt();
    }
}
}
