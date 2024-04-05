package servlet.service;

import java.util.List;
import java.util.Map;

public interface ServletService {
	String addStringTest(String str) throws Exception;

	List<Map<String, Object>> selectSD();

	List<Map<String, Object>> selectSGG();

	List<Map<String, Object>> selectBJD();

	List<Map<String, Object>> getSggList(String sdValue);

	List<Map<String, Object>> getBjdList(String sggValue);

	List<Map<String, Object>> getChartList();

	List<Map<String, Object>> bjdList(String bjdValue);

	List<Map<String, Object>> sdSelectChart(String sdCd1);

	List<Map<String, Object>> sdSelectTable(String sdCd1);

	List<Map<String, Object>> allselect();

	List<Map<String, Object>> chartList();


}

