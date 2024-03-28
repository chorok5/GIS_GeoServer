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


	Map<String, Double> getCoordinatesByCityName(String cityName);

}
