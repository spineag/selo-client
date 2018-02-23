/**
 * Created by andy on 10/20/17.
 */
package additional.pets {
import data.StructureDataPet;

public class DogPet extends PetMain  {
    public function DogPet(dPet:StructureDataPet) {
        super(dPet);

        _innerPosX1 = -44 * g.scaleFactor;
        _innerPosY1 = 60 * g.scaleFactor;
        _innerPosX2 = -104 * g.scaleFactor;
        _innerPosY2 = 92 * g.scaleFactor;
        _innerPosX3 = 62 * g.scaleFactor;
        _innerPosY3 = 102 * g.scaleFactor;
    }

    override public function releaseTexture():void {
        switch (_petData.id) {
            case 1: // pink_dog_big
                _animation.changeTexture("Orange_head_big_front.png",             "Pink_head_big_front", true);
                _animation.changeTexture("Orange_body_big_front.png",             "Pink_body_big_front", true);
                _animation.changeTexture("Orange_first_L_leg_big_front.png",      "Pink_first_L_leg_big_front", true);
                _animation.changeTexture("Orange_second_L_leg_big_front.png",     "Pink_second_R_leg_big_front", true);
                _animation.changeTexture("Orange_first_R_leg_big_front.png",      "Pink_first_R_leg_big_front", true);
                _animation.changeTexture("Orange_second_R_leg_big_front.png",     "Pink_second_L_leg_big_front", true);
                _animation.changeTexture("Orange_tail-end_big_front.png",         "Pink_tail-end_big_front", true);
                _animation.changeTexture("Orange_head_big_back.png",              "Pink_head_big_back", false);
                _animation.changeTexture("Orange_body_big_back.png",              "Pink_body_big_back", false);
                _animation.changeTexture("Orange_first_R_leg_big_back.png",       "Pink_first_R_leg_big_back", false);
                _animation.changeTexture("Orange_second_R_leg_big_back.png",      "Pink_second_R_leg_big_back", false);
                _animation.changeTexture("Orange_first_L_leg_big_back.png",       "Pink_first_L_leg_big_back", false);
                _animation.changeTexture("Orange_second_L_leg_big_back.png",      "Pink_second_L_leg_big_back", false);
                _animation.changeTexture("Orange_second_R_leg_big_back.png",      "Pink_second_R_leg_big_back", false);
                _animation.changeTexture("Orange_tail-end_big_back.png",          "Pink_tail-end_big_back", false);
                break;
            case 7: // red_dog_big
                _animation.changeTexture("Orange_head_big_front.png",             "Orange_head_big_front", true);
                _animation.changeTexture("Orange_body_big_front.png",             "Orange_body_big_front", true);
                _animation.changeTexture("Orange_first_L_leg_big_front.png",      "Orange_first_L_leg_big_front", true);
                _animation.changeTexture("Orange_second_L_leg_big_front.png",     "Orange_second_R_leg_big_front", true);
                _animation.changeTexture("Orange_first_R_leg_big_front.png",      "Orange_first_R_leg_big_front", true);
                _animation.changeTexture("Orange_second_R_leg_big_front.png",     "Orange_second_L_leg_big_front", true);
                _animation.changeTexture("Orange_tail-end_big_front.png",         "Orange_tail-end_big_front", true);

                _animation.changeTexture("Orange_head_big_back.png",              "Orange_head_big_back", false);
                _animation.changeTexture("Orange_body_big_back.png",              "Orange_body_big_back", false);
                _animation.changeTexture("Orange_first_R_leg_big_back.png",       "Orange_first_R_leg_big_back", false);
                _animation.changeTexture("Orange_second_R_leg_big_back.png",      "Orange_second_R_leg_big_back", false);
                _animation.changeTexture("Orange_first_L_leg_big_back.png",       "Orange_first_L_leg_big_back", false);
                _animation.changeTexture("Orange_second_L_leg_big_back.png",      "Orange_second_L_leg_big_back", false);
                _animation.changeTexture("Orange_second_R_leg_big_back.png",      "Orange_second_R_leg_big_back", false);
                _animation.changeTexture("Orange_tail-end_big_back.png",          "Orange_tail-end_big_back", false);
                break;
            case 8: // grey_dog_big
                _animation.changeTexture("Orange_head_big_front.png",             "Grey_head_big_front", true);
                _animation.changeTexture("Orange_body_big_front.png",             "Grey_body_big_front", true);
                _animation.changeTexture("Orange_first_L_leg_big_front.png",      "Grey_first_L_leg_big_front_", true);
                _animation.changeTexture("Orange_second_L_leg_big_front.png",     "Grey_second_R_leg_front", true);
                _animation.changeTexture("Orange_first_R_leg_big_front.png",      "Grey_first_R_leg_front", true);
                _animation.changeTexture("Orange_second_R_leg_big_front.png",     "Grey_second_L_leg_front", true);
                _animation.changeTexture("Orange_tail-end_big_front.png",         "Grey_tail-end_big_front", true);
                _animation.changeTexture("Orange_head_big_back.png",              "Grey_head_big_back", false);
                _animation.changeTexture("Orange_body_big_back.png",              "Grey_body_big_back", false);
                _animation.changeTexture("Orange_first_R_leg_big_back.png",       "Grey_first_R_leg_big_back", false);
                _animation.changeTexture("Orange_second_R_leg_big_back.png",      "Grey_second_R_leg_big_back", false);
                _animation.changeTexture("Orange_first_L_leg_big_back.png",       "Grey_first_L_leg_big_back", false);
                _animation.changeTexture("Orange_second_L_leg_big_back.png",      "Grey_second_L_leg_big_back", false);
                _animation.changeTexture("Orange_second_R_leg_big_back.png",      "Grey_R_leg_big_back", false);
                _animation.changeTexture("Orange_tail-end_big_back.png",          "Grey_tail-end_big_back", false);
                break;
        }
        super.releaseTexture();
    }

    public function clearIt():void {
        deleteIt();
    }
}
}
