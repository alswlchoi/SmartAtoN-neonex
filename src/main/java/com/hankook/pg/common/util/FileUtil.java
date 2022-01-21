package com.hankook.pg.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.Arrays;
import java.util.Comparator;


/**
 * @author Administrator
 *
 * 파일 입출력 관련 함수 모음
 */
public class FileUtil
{
	private static final Logger LOGGER = LoggerFactory.getLogger(FileUtil.class);
	private static String ENCODING = "UTF-8";

	
	/**
	  * 텍스트 파일의 내용을 읽음
	  * @param		fileName 파일 이름
	  * @returns	각 줄이 "\n"으로 구분된 문자열
	  */
	public static String readTextFile(String fileName)
	{
		return readTextFile(fileName,ENCODING);
	}
	public static String readTextFile(String fileName, String encoding)
	{
		StringBuffer buffer = new StringBuffer();
		if(fileName!=null && encoding!=null){
			FileInputStream fs = null;
			InputStreamReader is = null;
			BufferedReader reader = null;
			try {
				fs = new FileInputStream(fileName);
				is = new InputStreamReader(fs,encoding);
				reader = new BufferedReader(is);
				String line;
				while((line = reader.readLine()) != null) {
					buffer.append(line);
					buffer.append("\n");
				}
			}catch(IOException ioe) {
				LOGGER.debug("IOException : {fileName:"+fileName+",encoding:"+encoding+"} " + ioe.getMessage());
				buffer = new StringBuffer();
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {fileName:"+fileName+",encoding:"+encoding+"} " + se.getMessage());
				buffer = new StringBuffer();
			}catch(Exception e) {
				LOGGER.debug("Exception : {fileName:"+fileName+",encoding:"+encoding+"} " + e.getMessage());	
				buffer = new StringBuffer();
			}finally{
				if(reader!=null){try{reader.close();}catch(IOException e){LOGGER.debug("IOException : " + e.getMessage());}}
				if(is!=null){try{is.close();}catch(IOException e){LOGGER.debug("IOException : " + e.getMessage());}}
				if(fs!=null){try{fs.close();}catch(IOException e){LOGGER.debug("IOException : " + e.getMessage());}}
			}
		}
		return buffer.toString();
	}

	/**
	  * 문자열을 텍스트 파일에 기록
	  * @param		fileName 파일 이름
	  * @param		contents 기록할 내용
	  * @returns	성공 여부
	  */
	public static boolean writeTextFile(String fileName, String contents)
	{
		return writeTextFile(fileName, contents, ENCODING);
	}
	public static boolean writeTextFile(String fileName, String contents, String encoding)
	{
		if(fileName==null || contents==null || encoding==null){
			return false;
		}else{
			FileOutputStream fs = null;
			OutputStreamWriter os = null;
			BufferedWriter writer = null;
			try {
				fs = new FileOutputStream(fileName);
				os = new OutputStreamWriter(fs,encoding);
				writer = new BufferedWriter(os);
				writer.write(contents);
				writer.flush();
			}catch(IOException ioe) {
				LOGGER.debug("IOException : {fileName:"+fileName+",contents:"+contents+",encoding:"+encoding+"} " + ioe.getMessage());
				return false;
			}catch(Exception e) {
				LOGGER.debug("Exception : {fileName:"+fileName+",contents:"+contents+",encoding:"+encoding+"} " + e.getMessage());
				return false;
			}finally{
				if(writer!=null){try{writer.close();}catch(IOException e){LOGGER.debug("IOException : " + e.getMessage());}}
				if(os!=null){try{os.close();}catch(IOException e){LOGGER.debug("IOException : " + e.getMessage());}}
				if(fs!=null){try{fs.close();}catch(IOException e){LOGGER.debug("IOException : " + e.getMessage());}}
			}
			return true;
		}
	}

	/**
	  * 파일을 복사
	  * @param		srcFileName 원본 파일 이름
	  * @param		destFileName 대상 파일 이름
	  * @returns	복사된 바이트 수, 실패하면 -1
	  */
	public static int copyFile(String srcFileName, String destFileName)
	{
		if(srcFileName==null || destFileName==null){
			return -1;
		}else{
			try {
				File toFile = new File(destFileName);
				if( toFile.exists() ) return -1;
				else {
					byte[] buf = new byte[8192];
					int readbytes;
					int filesize = 0;
					FileInputStream fis = null;
					FileOutputStream fos = null;
					try {
						fis = new FileInputStream(srcFileName);
						fos = new FileOutputStream(destFileName);
						while((readbytes = fis.read(buf, 0, buf.length)) != -1) {
							filesize += readbytes;
							fos.write(buf, 0, readbytes);
							if(filesize<0){
								LOGGER.debug("OverFlow : {srcFileName:"+srcFileName+",destFileName:"+destFileName+"} ");
								break;
							}
						}
						fos.flush();
						fos.close();
						fis.close();
						return filesize;
					}catch (IOException ioe) {
						LOGGER.debug("IOException : {srcFileName:"+srcFileName+",destFileName:"+destFileName+"} " + ioe.getMessage());
						return -1;
					}catch(SecurityException se) {
						LOGGER.debug("SecurityException : {srcFileName:"+srcFileName+",destFileName:"+destFileName+"} " + se.getMessage());
						return -1;
					}catch (Exception e) {
						LOGGER.debug("Exception : {srcFileName:"+srcFileName+",destFileName:"+destFileName+"} " + e.getMessage());
						return -1;
					}finally{
						if(fos!=null){try{fos.close();}catch(IOException e){LOGGER.debug("IOException : " + e.getMessage());}}
						if(fis!=null){try{fis.close();}catch(IOException e){LOGGER.debug("IOException : " + e.getMessage());}}
					}
				}
			}catch(SecurityException se) {
				LOGGER.debug("IOException : {srcFileName:"+srcFileName+",destFileName:"+destFileName+"} " + se.getMessage());
				return -1;
			}catch(NullPointerException npe) {
				LOGGER.debug("NullPointerException : {srcFileName:"+srcFileName+",destFileName:"+destFileName+"} " + npe.getMessage());
				return -1;
			}catch(Exception e) {
				LOGGER.debug("Exception : {srcFileName:"+srcFileName+",destFileName:"+destFileName+"} " + e.getMessage());
				return -1;
			}
		}
	}
	
	/**
	  * 파일을 복사
	  * @param		srcFileName 원본 파일 이름
	  * @param		destFileName 대상 파일 이름
	  * @returns	복사된 파일명, 실패하면 공백
	  */
	public static String copyFile(String source_context, String copy_context, String source_file_nm){
		if(source_context==null || copy_context==null || source_file_nm==null){
			return "";
		}else{
			String file_full_nm = source_file_nm;
			source_context = replaceAll(replaceAll(source_context, "\\", "/") + "/", "//", "/");
			copy_context = replaceAll(replaceAll(copy_context, "\\", "/") + "/", "//", "/");
			if(file_full_nm.length()>0){
				String file_type = "";
				String file_nm =  "";
				if(file_full_nm!=null && file_full_nm.indexOf(".")>-1){
					file_type = file_full_nm.substring(file_full_nm.lastIndexOf(".") + 1).toLowerCase();
					file_nm = file_full_nm.substring(0, file_full_nm.lastIndexOf(".")).toLowerCase();
				}
				int idx = 1;
				while(exists(copy_context + file_full_nm)){
					file_full_nm = file_nm + "(" + idx++ + ")." + file_type;
				}
				copyFile(source_context + source_file_nm, copy_context + file_full_nm);
			}
			return file_full_nm;
		}
	}

	
	/**
	  * 파일 삭제
	  *
	  * @param     	filename 지울 파일 이름
	  * @returns	성공 여부
	  */
	public static boolean removeFile(String fileName)
	{
		if(fileName==null){
			return false;
		}else{
			try{
				File fi = new File(fileName);
				if(!fi.exists()) return false;
				if( fi.isDirectory() ){
					//return removeDir( fileName );
					return false;
				}
				return fi.delete();
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {fileName:"+fileName+"} " + se.getMessage());
				return false;
			}catch( Exception e){
				LOGGER.debug("Exception : {fileName:"+fileName+"} " + e.getMessage());
				return false;
			}
		}
	}
	
	/**
	  * 지정한 디렉토리에 파일 목록을 읽어 문자열 배열에 채움
	  *
	  * @param		pathName 디렉토리 경로
	  * @returns	성공시 문자열 배열, 실패시 null
	  */
	public static String[] fileList(String pathName)
	{
		if(pathName==null){
			return null;
		}else{
			try {
				File dir = new File(pathName);
				return dir.list();
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {pathName:"+pathName+"} " + se.getMessage());
				return null;
			}catch(Exception e) {
				LOGGER.debug("Exception : {pathName:"+pathName+"} " + e.getMessage());
				return null;
			}
		}
	}

	/**
	  * 파일 이동 또는 이름 변경
	  * @param		fromPath 원래 파일 이름 혹은 경로
	  * @param		toPath 새 파일 이름 혹은 경로
	  * @returns	성공 여부
	  */
	public static boolean moveFile(String fromPath, String toPath)
	{
		if(fromPath==null || toPath==null){
			return false;
		}else{
			try {
				File fromFile = new File(fromPath);
				File toFile = new File(toPath);
				if( toFile.exists() ) return false;
				fromFile.renameTo(toFile);
				return true;
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {fromPath:"+fromPath+",toPath:"+toPath+"} " + se.getMessage());
				return false;
			}catch(Exception e) {
				LOGGER.debug("Exception : {fromPath:"+fromPath+",toPath:"+toPath+"} " + e.getMessage());
				return false;
			}
		}
	}

	public static String moveFile(String source_context, String move_context, String source_file_nm){
		if(source_context==null || move_context==null || source_file_nm==null){
			return "";
		}else{
			String file_full_nm = source_file_nm;
			source_context = replaceAll(replaceAll(source_context, "\\", "/") + "/", "//", "/");
			move_context = replaceAll(replaceAll(move_context, "\\", "/") + "/", "//", "/");
			if(file_full_nm.length()>0){
				String file_type = "";
				String file_nm =  "";
				if(file_full_nm!=null && file_full_nm.indexOf(".")>-1){
					file_type = file_full_nm.substring(file_full_nm.lastIndexOf(".") + 1).toLowerCase();
					file_nm = file_full_nm.substring(0, file_full_nm.lastIndexOf(".")).toLowerCase();
				}
				int idx = 1;
				while(exists(move_context + file_full_nm)){
					file_full_nm = file_nm + "(" + idx++ + ")." + file_type;
				}
				moveFile(source_context + source_file_nm, move_context + file_full_nm);
			}
			return file_full_nm;
		}
	}
	/**
	  * 새로운 파일(디렉토리 아님~) 생성
	  * @param		fileName
	  * @returns	true or false
	  */
	public static boolean createNewFile(String fileName)
	{
		if(fileName==null){
			return false;
		}else{
			try {
				File file = new File(fileName);
				if( file.exists() ) return false;
				file.createNewFile();
				return true;
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {fileName:"+fileName+"} " + se.getMessage());
				return false;
			}catch(IOException ioe) {
				LOGGER.debug("IOException : {fileName:"+fileName+"} " + ioe.getMessage());
				return false;
			}catch(Exception e) {
				LOGGER.debug("Exception : {fileName:"+fileName+"} " + e.getMessage());
				return false;
			}
		}
	}

	/**
	  * 새로운 파일 생성 및 내용 추가
	  * @param		fileName, str
	  * @returns	true or false
	  */
	public static boolean createNewFile(String fileName, String str){
		if(fileName==null || str==null){
			return false;
		}else{
			// 파일 삭제
			removeFile(fileName);
			// 파일 생성
			if(createNewFile(fileName)){
				// 내용 작성
				writeTextFile(fileName, str);
			}
			return exists(fileName);
		}
	}

	/**
	  * 특정디렉토리를 생성함.
	  * @param		dirPath
	  * @return		디렉토리를 성공적으로 생성하면  true, 그렇지 않으면  false
	  */
	public static boolean makeDir(String dirPath)
	{
		if(dirPath==null){
			return false;
		}else{
			try{
				File theDir = new File(dirPath);
				boolean result = theDir.mkdirs();
				//if( !result ) Log("Can't make dir " + dirPath );
				return result;
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {dirPath:"+dirPath+"} " + se.getMessage());
				return false;
			}catch( Exception e ){
				LOGGER.debug("Exception : {dirPath:"+dirPath+"} " + e.getMessage());
				return false;
			}
		}
	}

	/**
	  * 특정디렉토리를 생성함.
	  * @param		parentPath, childPath
	  * @return		디렉토리를 성공적으로 생성하면  true, 그렇지 않으면  false
	  */
	public static boolean makeDir(String parentPath, String childPath)
	{
		if(parentPath==null || childPath==null){
			return false;
		}else{
			try{
				File theDir = new File(parentPath, childPath);
				return theDir.mkdirs();
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {parentPath:"+parentPath+",childPath:"+childPath+"} " + se.getMessage());
				return false;
			}catch( Exception e ){
				LOGGER.debug("Exception : {parentPath:"+parentPath+",childPath:"+childPath+"} " + e.getMessage());
				return false;
			}
		}
	}

	/** 현재 디렉토리의 사용량을 리턴합니다 ( 하위디렉토리 포함 ) */
	public static long sizeDir(String path ) throws IOException
	{
		if(path==null){
			return 0;
		}else{
			long size = 0;
			try{
				File fp	= new File(path);
				if( !fp.exists() ) return 0;
				File[] lfile = fp.listFiles();
				if(lfile!=null){
					for ( int i=0; i < lfile.length;i++){
						// 디렉토리 인가..?
						if( lfile[i].isDirectory() )
							size += sizeDir( lfile[i].getAbsolutePath() );	
						size += lfile[i].length();	
					}
				}
			}catch(IOException ioe){
				LOGGER.debug("IOException : {path:"+path+"} " + ioe.getMessage());
				size = 0;
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {path:"+path+"} " + se.getMessage());
				size = 0;
			}catch( Exception e ){
				LOGGER.debug("Exception : {path:"+path+"} " + e.getMessage());
				size = 0;
			}
			return size;
		}
	}


	/**
	  * 특정디렉토리를 복사함.
	  * @param		srcPath, destPath
	  * @return		디렉토리를 성공적으로 복사하면  true, 그렇지 않으면  false
	  */
	public static boolean copyDir(String srcPath, String destPath) throws IOException
	{
		if(srcPath==null || destPath==null){
			return false;
		}else{
			/////////////////////////////////////////////////
			// 자신의 자신의 서브디렉토리로 복사할려고 하면
			// false 를 리턴합니다.
			if( destPath.startsWith( srcPath )) return false;
			////////////////////////////////////////////////
	
			File fp	= new File(srcPath);
			File[] lfile = fp.listFiles();
			int i = 0;
			makeDir(destPath);
			for (; ; )
			{
				try{
					if (lfile[i].isDirectory()){
						makeDir(destPath+lfile[i].getName());
						copyDir(lfile[i].getAbsolutePath()+"/", destPath+lfile[i].getName()+"/");
					}
					copyFile(lfile[i].getAbsolutePath(), destPath+lfile[i].getName());
					i++;
				}catch(IOException ioe){
					LOGGER.debug("IOException : {srcPath:"+srcPath+", destPath:"+destPath+"} " + ioe.getMessage());
					break;
				}catch(SecurityException se) {
					LOGGER.debug("SecurityException : {srcPath:"+srcPath+", destPath:"+destPath+"} " + se.getMessage());
					break;
				}catch( Exception e){
					LOGGER.debug("Exception : {srcPath:"+srcPath+", destPath:"+destPath+"} " + e.getMessage());
					break;
				}
			}
			try{
				//fp.delete();
				return true;
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {srcPath:"+srcPath+", destPath:"+destPath+"} " + se.getMessage());
				return false;
			}catch( Exception e){
				LOGGER.debug("Exception : {srcPath:"+srcPath+", destPath:"+destPath+"} " + e.getMessage());
				//Log("FileUtil.copyDir Error::" + e.getMessage() );
				return false;
			}
		}
	}

	/**
	  * 디렉토리 삭제
	  * (수정) 잉크 : 디렉토리도 같이 삭제를 하는 루틴을 만들어 넣어 습니다.
	  * @param     	filePath 지울 데렉토리 이름
	  * @returns	성공 여부
	  */
	public static boolean removeDir(String filePath) throws IOException{
		if(filePath==null){
			return false;
		}else{
			boolean isRemoveDir = true;
			File fp	= new File(filePath);
			if(fp!=null){
				File[] lfile = fp.listFiles();
				if(lfile!=null){
					for (int i=0; i < lfile.length; i++)
					{
						try{
							// 지우고자 하는게 다시 디렉토리라면, 자기
							// 자신을 다시 호출한다.
							if (lfile[i].isDirectory()) removeDir(lfile[i].getAbsolutePath());
								lfile[i].delete();
						}catch(IOException ioe){
							LOGGER.debug("IOException : {filePath:"+filePath+"} " + ioe.getMessage());
							break;
						}catch(SecurityException se) {
							LOGGER.debug("SecurityException : {filePath:"+filePath+"} " + se.getMessage());
							break;
						}catch( Exception e){
							LOGGER.debug("Exception : {filePath:"+filePath+"} " + e.getMessage());
							break;
						}
					}
				}
			
				try{
					fp.delete();
					isRemoveDir = true;
				}catch(SecurityException se) {
					LOGGER.debug("SecurityException : {filePath:"+filePath+"} " + se.getMessage());
					isRemoveDir = false;
				}catch( Exception e){
					LOGGER.debug("Exception : {filePath:"+filePath+"} " + e.getMessage());
					isRemoveDir = false;
				}
			}
			return isRemoveDir;
		}
	}

	/**
	 * 파일이 존재하는지 여부를 묻는다.
	 * @param		fileName	물리적 경로의 파일명
	 * @return		존재하면 true, 존재하지 않으면 false를 리턴한다.
	 */
	public static boolean exists(String fileName)
	{
		if(fileName==null){
			return false;
		}else{
			boolean res = false;
			try {
				File f = new File(fileName);
				if(f.exists()) res = true;
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {fileName:"+fileName+"} " + se.getMessage());
				res = true;;
			}catch( Exception e){
				LOGGER.debug("Exception : {fileName:"+fileName+"} " + e.getMessage());
				res = true;
			}
			return res;
		}
	} //exists



	/**
	 * 특정 디렉토리내의 모든 파일을 삭제합니다
	 *
	 * @param	dirname		비울 디렉토리 이름
	 * @return	true/false	성공여부
	 */
	public static boolean emptyDir( String dirname ) throws IOException
	{
		if(dirname==null){
			return false;
		}else{
			boolean result = true;
			File dir = new File( dirname );
	
			if( dir.exists() && dir.isDirectory() )
			{
				String[] files = fileList( dirname );
				if(files==null){
					result = false;
				}else{
					for( int i=0; i < files.length; i++ )
					{
						result = result & removeFile( dirname + File.separator + files[i] );
					}
				}
			}
			else
			{
				result = false;
			}
			return result;
		}
	}
	
	/**
	 * 파일의 최종 수정 일자
	 *
	 * @param	fileName	물리적 경로의 파일명
	 * @return	Long 
	 */
	public static long lastModified( String fileName ) throws IOException
	{
		if(fileName==null){
			return 0;
		}else{
			try{
				File f = new File(fileName);
				return f.lastModified();
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {fileName:"+fileName+"} " + se.getMessage());
				return 0;
			}catch( Exception e){
				LOGGER.debug("Exception : {fileName:"+fileName+"} " + e.getMessage());
				return 0;
			}
		}
	}
	

	
	public static long getFileSize(String fileName) throws IOException {
		if(fileName==null){
			return 0;
		}else{
			try{
				return getFileSize(new File(fileName));
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {fileName:"+fileName+"} " + se.getMessage());
				return 0;
			}catch( Exception e){
				LOGGER.debug("Exception : {fileName:"+fileName+"} " + e.getMessage());
				return 0;
			}
		}
	}

	public static long getFileSize(File file) {
		if(file==null){
			return 0;
		}else{
			return file.length();
		}
	}
	
	public static String toDisplaySize(String file) {
		if (file == null || file.length() == 0)
			return "";
		else
			return toDisplaySize(new File(file));
	}

	public static String toDisplaySize(File file) {
		if (file == null || !file.exists())
			return "";
		else
			return toDisplaySize(file.length());
	}

	public static String toDisplaySize(long size) {
		return toDisplaySize(Long.valueOf(String.valueOf(size)).intValue());
	}

	public static String toDisplaySize(int size) {
		String displaySize;
		if (size / 1073741824 > 0)
			displaySize = String.valueOf(size / 1073741824) + " GB";
		else if (size / 1048576 > 0)
			displaySize = String.valueOf(size / 1048576) + " MB";
		else if (size / 1024 > 0)
			displaySize = String.valueOf(size / 1024) + " KB";
		else
			displaySize = String.valueOf(size) + " bytes";
		return displaySize;
	}
	
	public static File[] sortListFiles(File dir) {
		if (dir == null){
			return null;
		}else{	
			File fs[] = dir.listFiles();
			if (fs != null && fs.length > 1)
				Arrays.sort(fs, new Comparator<Object>() {
	
					public int compare(Object a, Object b) {
						File filea = (File) a;
						File fileb = (File) b;
						if (filea.isDirectory() && !fileb.isDirectory())
							return -1;
						if (!filea.isDirectory() && fileb.isDirectory())
							return 1;
						else
							return filea.getName().compareToIgnoreCase(
									fileb.getName());
					}
	
				});
			return fs;
		}
	}

	
	/**
	 * @param fileUrl
	 * @param saveFileName
	 * @param savePathName
	 * @return
	 * Description URL 링크 상의 파일 다운로드
	 */
	public static int fileUrlReadAndDownload(String fileUrl, String saveFileName, String savePathName) {
		int byteWritten = 0;
		if (fileUrl != null && saveFileName != null && savePathName != null){
			try {
				byteWritten = fileUrlReadAndDownload(fileUrl, savePathName + File.separator + URLDecoder.decode(saveFileName, ENCODING));
			} catch (UnsupportedEncodingException uee) {
				LOGGER.debug("UnsupportedEncodingException : {fileUrl:"+fileUrl+",saveFileName:"+saveFileName+",savePathName:"+savePathName+"} " + uee.getMessage());
				byteWritten = 0;
			} catch (Exception e) {
				LOGGER.debug("Exception : {fileUrl:"+fileUrl+",saveFileName:"+saveFileName+",savePathName:"+savePathName+"} " + e.getMessage());
				byteWritten = 0;
			}
		}
		return byteWritten;
	}
	
	public static int fileUrlReadAndDownload(String fileUrl, String saveFileName) {
		OutputStream outStream = null;
		InputStream is = null;
		int byteWritten = 0;
		if (fileUrl != null && saveFileName != null){
			try {
				outStream = new BufferedOutputStream(new FileOutputStream(saveFileName));
				is = new URL(fileUrl).openConnection().getInputStream();
				
				byte[] buf = new byte[1024];
				int byteRead;
				while ((byteRead = is.read(buf)) != -1) {
					outStream.write(buf, 0, byteRead);
					byteWritten += byteRead;
					if(byteWritten<0){
						LOGGER.debug("OverFlow : {fileUrl:"+fileUrl+",saveFileName:"+saveFileName+"}");
						break;
					}					
				}
			}catch(IOException ioe){
				LOGGER.debug("IOException : {fileUrl:"+fileUrl+",saveFileName:"+saveFileName+"} " + ioe.getMessage());
				byteWritten = 0;
			}catch(SecurityException se) {
				LOGGER.debug("SecurityException : {fileUrl:"+fileUrl+",saveFileName:"+saveFileName+"} " + se.getMessage());
				byteWritten = 0;
			}catch( Exception e){
				LOGGER.debug("Exception : {fileUrl:"+fileUrl+",saveFileName:"+saveFileName+"} " + e.getMessage());
				byteWritten = 0;
			}finally{
				if(is!=null){try{is.close();}catch(IOException e){LOGGER.debug("IOException : " + e.getMessage());}}
				if(outStream!=null){try{outStream.close();}catch(IOException e){LOGGER.debug("IOException : " + e.getMessage());}}
			}
		}
		return byteWritten;
	}
	
	private static String replaceAll( String str, String s1, String s2 ){
		str = toString(str);
		if(s1!=null && s2!=null){
			StringBuffer result = new StringBuffer();
			if(s1.length()>0){				
				String s = str;
				int index1 = 0;
				int index2 = s.indexOf(s1);
		
				while(index2 >= 0) {
					result.append( str.substring(index1, index2) );
					result.append( s2 );
					index1 = index2 + s1.length();
					index2 = s.indexOf(s1, index1);
				}
				result.append( str.substring( index1 ) );
			}else{
				result.append(str);
			}
			return result.toString();
		}else{
			return str;
		}		
	}
	private static String toString(String value){
		return (value==null || value.trim().equals("") || value.equals("null"))? "" : value;
	}
		
	
}//FileUtil

