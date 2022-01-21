<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/jsp/common/adminHeader.jsp" %>
<sec:csrfMetaTags/>
<script type="text/javascript">
$(function(){
	$("#registerBtn").click(function(){
	})

})
</script>
<!-- container -->
        <div id="container">
            <!-- content -->
            <div class="content">
                <!-- breadcrumb -->
                <div class="breadcrumb"><span class="breadcrumb_icon"></span><span>시험자원관리</span><span>타이어/휠 관리</span><span>Wheel data update</span>
                </div>
                <!-- //breadcrumb -->
                <!-- title -->
                <h2 class="title">Wheel data update</h2>
                <!-- //title -->

                <!-- search_wrap -->
                <section class="search_wrap">
                    <div class="form_group w300">
                        <input type="text" id="" class="form_control" placeholder="file name 입력" name="" />
                    </div>
                    <button type="button" class="btn-s btn_default">조회</button>
                    <section class="disib fr">
                        <button type="button" class="btn-line btn_gray m-r-6">양식 다운로드</button>
                        <button type="button" class="btn-line btn_default">Upload</button>
                    </section>
                </section>
                <!-- //search_wrap -->
                <!-- table list -->
                <section class="tbl_wrap_list m-t-30">
                    <table class="tbl_list" summary="테이블 입니다. 항목으로는 등이 있습니다">
                        <caption>테이블</caption>
                        <colgroup>
                            <col width="" />
                            <col width="" />
                            <col width="" />
                            <col width="" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">File name</th>
                                <th scope="col">Upload date</th>
                                <th scope="col">등록자</th>
                                <th scope="col">등록일시</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><a href="#">wheel_data_2021.xls</a></td>
                                <td>2021.07.29 16:45:21</td>
                                <td>admin122</td>
                                <td>20201.07.29 13:00:00</td>
                            </tr>
                            <tr>
                                <td><a href="#">wheel_data_2021.xls</a></td>
                                <td>2021.07.29 16:45:21</td>
                                <td>admin122</td>
                                <td>20201.07.29 13:00:00</td>
                            </tr>
                            <tr>
                                <td><a href="#">wheel_data_2021.xls</a></td>
                                <td>2021.07.29 16:45:21</td>
                                <td>admin122</td>
                                <td>20201.07.29 13:00:00</td>
                            </tr>
                            <tr>
                                <td><a href="#">wheel_data_2021.xls</a></td>
                                <td>2021.07.29 16:45:21</td>
                                <td>admin122</td>
                                <td>20201.07.29 13:00:00</td>
                            </tr>
                            <tr>
                                <td><a href="#">wheel_data_2021.xls</a></td>
                                <td>2021.07.29 16:45:21</td>
                                <td>admin122</td>
                                <td>20201.07.29 13:00:00</td>
                            </tr>
                            <tr>
                                <td><a href="#">wheel_data_2021.xls</a></td>
                                <td>2021.07.29 16:45:21</td>
                                <td>admin122</td>
                                <td>20201.07.29 13:00:00</td>
                            </tr>
                            <tr>
                                <td><a href="#">wheel_data_2021.xls</a></td>
                                <td>2021.07.29 16:45:21</td>
                                <td>admin122</td>
                                <td>20201.07.29 13:00:00</td>
                            </tr>
                            <tr>
                                <td><a href="#">wheel_data_2021.xls</a></td>
                                <td>2021.07.29 16:45:21</td>
                                <td>admin122</td>
                                <td>20201.07.29 13:00:00</td>
                            </tr>
                            <tr>
                                <td><a href="#">wheel_data_2021.xls</a></td>
                                <td>2021.07.29 16:45:21</td>
                                <td>admin122</td>
                                <td>20201.07.29 13:00:00</td>
                            </tr>
                            <tr>
                                <td><a href="#">wheel_data_2021.xls</a></td>
                                <td>2021.07.29 16:45:21</td>
                                <td>admin122</td>
                                <td>20201.07.29 13:00:00</td>
                            </tr>
                            <!-- <tr class="tr_nodata">
                <td colspan="4">등록된 정보가 없습니다.</td>
            </tr> -->
                        </tbody>
                    </table>
                </section>
                <!-- //table list -->
                <!-- Pagination -->
                <section class="pagination m-t-30">
                    <a class="btn_prev off" href="#">
                        <i class="fas fa-angle-left"></i>
                    </a>
                    <span class='wrap'>
                        <a href='#' class='on'>1</a>
                        <a href="#">2</a>
                        <a href="#">3</a>
                        <span class="more"></span>
                        <a href="#">999</a>
                    </span>
                    <a class="btn_next" href="#">
                        <i class="fas fa-angle-right"></i>
                    </a>
                </section>
                <!-- //Pagination -->
            </div>
            <!-- //content -->
            <!-- quickmenu -->
            <div class="quickmenu_wrap">
                <section>
                    <a href="#" class="test" title="시험로 시험관리">시험로<br />시험관리</a>
                    <a href="#" class="gate" title="게이트 제어">게이트<br />제어</a>
                    <a href="#" class="schedule" title="스케줄 관리">스케줄<br />관리</a>
                </section>
                <a href="#" class="top" title="위로 이동"></a>
            </div>
            <!-- //quickmenu -->
        </div>
        <!-- //container -->
<%@ include file="/WEB-INF/views/jsp/common/adminFooter.jsp" %>