/**
 * Created by user on 7/10/18.
 */
package user {
import manager.Vars;

public class UserAnalytics {
    public var buyPaper:int = 0;
    public var doneOrder:int = 0;
    public var doneNyashuk:int = 0;
    public var countSession:int = 1;

    private var g:Vars = Vars.getInstance();

    public function UserAnalytics() {
        g.server.getUserAnalytics(null);
    }
}
}
