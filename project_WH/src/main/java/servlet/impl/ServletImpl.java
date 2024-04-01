package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.service.ServletService;

@Service("ServletService")
public class ServletImpl extends EgovAbstractServiceImpl implements ServletService{
	
	@Resource(name="ServletDAO")
	private ServletDAO dao;
	
	
	public String addStringTest(String str) throws Exception {
		List<EgovMap> mediaType = dao.selectAll();
		return str + " -> testImpl ";
	}

	@Override
	public List<Map<String, Object>> selectSD() {
		return dao.selectList("servlet.sdlist");
	}

	@Override
	public List<Map<String, Object>> selectSGG() {
		return dao.selectList("servlet.sgglist");
	}

	@Override
	public List<Map<String, Object>> selectBJD() {
		return dao.selectList("servlet.bjdlist");
	}

	@Override
	public List<Map<String, Object>> getSggList(String sdValue) {
		return dao.selectList("servlet.getSgg",sdValue);
		
	}

	@Override
	public List<Map<String, Object>> getBjdList(String sggValue) {
		return dao.selectList("servlet.getBjd",sggValue);
	}

	/*
	 * @Override public List<Map<String, Object>> getChartData() { return
	 * dao.selectList("servlet.getChartData"); }
	 */

}
