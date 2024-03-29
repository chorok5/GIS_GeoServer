package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import servlet.service.FileService;
import servlet.service.ServletService;

@RestController
public class RestFullController {

    @Autowired
    private ServletService servletService;
    
	@Resource(name="FileService")
	private FileService fileService;
    
    @PostMapping("/getSggList.do")
    public List<Map<String, Object>> getSggList(@RequestParam("sdValue") String sdValue) {
      List<Map<String, Object>> list = servletService.getSggList(sdValue);
      System.out.println(list);
      return list;
    }
    
    @PostMapping("/getBjdList.do")
    public List<Map<String, Object>> getBjdList(@RequestParam("sggValue") String sggValue) {
    	List<Map<String, Object>> list1 = servletService.getBjdList(sggValue);
    	System.out.println(list1);
    	return list1;
    }
    
    
	@RequestMapping(value = "/t-file.do", method = RequestMethod.GET)
	public String t_file() {
		return "main/t_file";
	}

	@ResponseBody
	@RequestMapping(value = "/t-file2.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	public String t_file2(@RequestParam("file") MultipartFile upFile) throws IOException {

		  List<Map<String, Object>> list = new ArrayList<>();
		  InputStreamReader isr = new InputStreamReader(upFile.getInputStream());
		  BufferedReader br = new BufferedReader(isr);
		  String line = null;
		  
		  while ((line = br.readLine()) != null) {
		    Map<String, Object> m = new HashMap<>();
		    String[] lineArr = line.split("\\|");
		    m.put("date", lineArr[0]); // 사용_년월 date
			m.put("addr", lineArr[1]); // 대지_위치 addr
			m.put("newaddr", lineArr[2]); // 도로명_대지_위치 newAddr
			m.put("sgg_cd", lineArr[3]); // 시군구_코드 sigungu
			m.put("bjd_cd", lineArr[4]); // 법정동_코드 bubjungdong
			m.put("site_div_cd", lineArr[5]); // 대지_구분_코드 addrCode
			m.put("bun", lineArr[6]); // 번 bun
			m.put("ji", lineArr[7]); // 지 si
			m.put("newaddr_cd", lineArr[8]); // 새주소_일련번호 newAddrCode
			m.put("newaddr_roadcd", lineArr[9]); // 새주소_도로_코드 newAddr
			m.put("newaddr_undernd", lineArr[10]);// 새주소_지상지하_코드newAddrUnder
			m.put("newaddr_mainno", !lineArr[11].isEmpty() ? Integer.parseInt(lineArr[11]):0 ); // 새주소_본_번 newAddrBun
			m.put("newaddr_subno", !lineArr[12].isEmpty() ? Integer.parseInt(lineArr[12]):0); // 새주소_부_번 newAddrBun2
			m.put("used_kwh", !lineArr[13].isEmpty() ? Integer.parseInt(lineArr[13]):0); // 사용_량(KWh)

			list.add(m);

		}
		System.out.println("종료 : " + list);
		
		fileService.uploadFile(list);
		
		br.close();
		isr.close();

		return "success";
	}
}












