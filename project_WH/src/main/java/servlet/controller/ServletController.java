package servlet.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.ws.rs.GET;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.service.ServletService;

@Controller
public class ServletController {

	@Resource(name = "ServletService")
	private ServletService servletService;

	@RequestMapping(value = "/main.do")
	public String mainTest(ModelMap model) throws Exception {
		System.out.println("main start");
		List<Map<String, Object>> sdList = servletService.selectSD();
		List<Map<String, Object>> sggList = servletService.selectSGG();
		List<Map<String, Object>> bjdList = servletService.selectBJD();

		model.addAttribute("sdList", sdList);
		model.addAttribute("sggList", sggList);
		model.addAttribute("bjdList", bjdList);

		return "main/main";
	}

	// chart

	@RequestMapping(value = "/chart.do", method = RequestMethod.GET)
	public String chart1(Model model) {
		List<Map<String, Object>> chartList = servletService.chartList();
		model.addAttribute("chartList", chartList);
		System.out.println(chartList);
		return "main/chart";
	}

	// 전체 선택 (allSelected)
	@RequestMapping(value = "/allSelect.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> allSelected() {
		System.out.println("시도 전체 차트");
		List<Map<String, Object>> allSelect = servletService.allselect();
		//model.addAttribute("allSelect", allSelect);
		System.out.println(allSelect);
		return allSelect;
	}

	// 시도 차트 (sdSelecChart)
	@RequestMapping(value = "/sdSelectChart.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> drawChart(@RequestParam("sdCd1") String sdCd1, Model model) {
		List<Map<String, Object>> sdSelectChart = servletService.sdSelectChart(sdCd1);
		model.addAttribute("sdSelectChart", sdSelectChart);
		System.out.println(sdSelectChart);
		return sdSelectChart;
	}

	// 시도 테이블 (sdSelectTable)
	@RequestMapping(value = "/sdSelectTable.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> drawTable(@RequestParam("sdCd1") String sdCd1, Model model) {
		List<Map<String, Object>> sdSelectTable = servletService.sdSelectTable(sdCd1);
		model.addAttribute("sdSelectTable", sdSelectTable);
		System.out.println(sdSelectTable);
		return sdSelectTable;
	}

}
