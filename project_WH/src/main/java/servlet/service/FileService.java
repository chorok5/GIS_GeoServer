package servlet.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public interface FileService {

	void uploadFile(List<Map<String, Object>> list);
}
