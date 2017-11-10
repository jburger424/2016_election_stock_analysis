import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.Normalizer;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Stream;

/**
 * Created by Jon on 11/16/16.
 */
public class main {
    //http://stackoverflow.com/questions/453018/number-of-lines-in-a-file-in-java
    public static int countLines(String filename) throws IOException {
        InputStream is = new BufferedInputStream(new FileInputStream(filename));
        try {
            byte[] c = new byte[1024];
            int count = 0;
            int readChars = 0;
            boolean empty = true;
            while ((readChars = is.read(c)) != -1) {
                empty = false;
                for (int i = 0; i < readChars; ++i) {
                    if (c[i] == '\n') {
                        ++count;
                    }
                }
            }
            return (count == 0 && !empty) ? 1 : count;
        } finally {
            is.close();
        }
    }
    public static void csvImport(String dbName, String filename){
        try{
            int numLines = countLines(filename) + 1;
            Scanner scanner = new Scanner(new File(filename));


            scanner.useDelimiter("\n");
            String[] headers = scanner.next().split(",");
            String[][] data = new String[numLines][headers.length];
            int index = 0;
            while(scanner.hasNext()){
                data[index] = scanner.next().split(",");
                index++;
                //System.out.println("index: "+index);
            }
            scanner.close();

            Insert insert = new Insert();
            System.out.println(Arrays.toString(headers));
            insert.insert(dbName,headers,data,numLines,data[0].length);
        }
        catch (Exception e){
            e.printStackTrace();
        }



    }
    public static String[] getCompanySymbols(){
        //apparently not really 500
        String[] symbols = new String[505];
        try{
            Scanner scanner = new Scanner(new File("/Users/Jon/Google_Drive/Comp321/stock-election-db/s_and_p_500.csv"));
            scanner.useDelimiter("\n");
            //skip the header
            scanner.next();
            int index = 0;
            while(scanner.hasNext()){
                symbols[index] = scanner.next().split(",")[0];
                index++;
            }
            scanner.close();
        }
        catch (Exception e){
            e.printStackTrace();
        }

        return symbols;

    }
    //from 11/2/16 to 11/15/16
    public static double[] getCloseArray(String symbol){
        double[] closeVals = new double[10];
        int index = 0;
        try{
            URL url = new URL(
                            "http://ichart.finance.yahoo.com/table.csv?s="+
                            symbol+
                            "&d=10&e=15&f=2016&g=d&a=10&b=2&c=2016&ignore=.csv");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            if (connection.getResponseCode() == 200) {
                InputStreamReader streamReader = new InputStreamReader(connection.getInputStream());
                BufferedReader br = new BufferedReader(streamReader);
                //skips header row
                String line = br.readLine();
                double startVal = -1;
                while ((line = br.readLine()) != null) {
                    if (index == 0) {
                        startVal = parseLine(line);
                        closeVals[index] = 0;
                    } else {
                        double tempVal = parseLine(line);
                        double adjustedVal = (tempVal - startVal) / startVal;
                        closeVals[index] = adjustedVal;
                    }
                    index++;
                }

            }
        }
        catch (Exception e){
            e.printStackTrace();
        }
        return closeVals;
    }
    public static double parseLine(String line){
        return Double.parseDouble(line.split(",")[4]);
    }
    public static void main(String args[]){
        //accounts for weekends
       double[] dayVals = {0,1,2,5,6,7,8,9,12,13};

        String[] symbols = getCompanySymbols();
        String[] headers = {"symbol","slope_diff"};
        String[][] data = new String[symbols.length][2];
        for (int i = 0; i < symbols.length; i++) {
            String symbol = symbols[i];

            double[] closeVals = getCloseArray(symbol);
            LinearRegression regressionPre = new LinearRegression(Arrays.copyOfRange(dayVals, 0, 5),Arrays.copyOfRange(closeVals, 0, 5));
            LinearRegression regressionPost = new LinearRegression(Arrays.copyOfRange(dayVals, 5, 10),Arrays.copyOfRange(closeVals, 5, 10));
            double slopePre = regressionPre.slope();
            double slopePost = regressionPost.slope();
            double slopeDiff = slopePost - slopePre;
            data[i][0] = symbol;
            data[i][1] = String.valueOf(slopeDiff);
            /*if(slopeDiff > 0){
                System.out.println("\n*"+symbol+"*");
                System.out.println("SlopeDiff: "+slopeDiff);
                System.out.println("SlopePre: "+slopePre);
                System.out.println("SlopePost: "+slopePost);
                System.out.println("SlopePost: "+slopePost);
            }*/

        }
        Insert insert = new Insert();
        insert.insert("stocks",headers,data,symbols.length,2);
        System.out.println("Stocks complete");

        /*csvImport("s_and_p","/Users/Jon/Google_Drive/Comp321/stock-election-db/s_and_p_500.csv");
        System.out.println("S&P Complete");
        csvImport("cities","/Users/Jon/Google_Drive/Comp321/stock-election-db/us.csv");
        System.out.println("Cities Complete");
        csvImport("pres_results","/Users/Jon/Google_Drive/Comp321/stock-election-db/pres16results_county.csv");
        System.out.println("Results Complete");*/
    }
}
