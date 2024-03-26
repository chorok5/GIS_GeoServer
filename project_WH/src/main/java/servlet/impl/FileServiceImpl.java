package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import servlet.service.FileService;

@Service("FileService")
public class FileServiceImpl extends EgovAbstractServiceImpl implements FileService{
	@Resource(name="ServletDAO")
	private ServletDAO dao;
	
	@Override
	public void uploadFile(List<Map<String, Object>> list) {
				
		for (Map<String, Object> map : list) {
			dao.selectList("servlet.uploadFile",map);
		}
	}

}
