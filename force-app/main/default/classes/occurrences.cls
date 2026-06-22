public class occurrences {
    public static Map<String , Integer> countOcurrences (List<String> inputList ){
        Map<String, Integer> stringCounts = new Map<String, Integer>();
        if (inputList == null) {
            return stringCounts;
        }
        for (String str : inputList) {
            
        if (stringCounts.containsKey(str)) {
            stringCounts.put(str,stringCounts.get(str)+1);
    }
            else {
                stringCounts.put(str,1);
                    }
}
        return stringCounts;
    }
}