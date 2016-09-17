/**
 * Created by akimchukdaniel on 9/17/16.
 */

import com.amazonaws.util.json.JSONArray;
import com.amazonaws.util.json.JSONObject;

import java.net.URL;
import java.util.Scanner;

public class FileInput {

    public static void main(String[] args) {
        String s = "http://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=DEMO_KEY&nutrients=205&nutrients=204&nutrients=208&nutrients=269";
        try {
            URL url = new URL(s);
            Scanner scan = new Scanner(url.openStream());
            String str = new String();
            while (scan.hasNext()) {
                str += scan.nextLine();
            }
            scan.close();
            JSONObject obj = new JSONObject(str);
            obj = (JSONObject) obj.get("report");
            JSONArray array = (JSONArray) obj.get("foods");
            for (int i = 0; i < array.length(); i++) {
                obj = array.getJSONObject(i);
                System.out.println(obj.get("name"));
            }
        } catch (Exception e) {
            System.out.println("error");
        }
    }
}
