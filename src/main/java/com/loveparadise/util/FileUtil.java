package com.loveparadise.util;

import java.io.File;
import java.util.Date;

public class FileUtil {
	public void delteFiles() {
		String path = "";
		File file = null;
		Date now = new Date();

		// 删除条码文件 boxPates\barCodeFiles
		String basePath = System.getProperty("user.dir").replace("bin", "");
		path = basePath + "boxPates\\barCodeFiles\\";
		file = new File(path);
		if (file.exists() && file.isDirectory()) {
			String[] filelist = file.list();
			for (int i = 0; i < filelist.length; i++) {
				File readfile = new File(path + "\\" + filelist[i]);
				if (!readfile.isDirectory()) {
					Date modify = new Date(readfile.lastModified());
					Long diff = now.getTime() - modify.getTime();
					if (diff / (1000 * 60) >= 20) {
						readfile.delete();
					}
				}
			}
		}

		// 删除条码下载生成的临时文件 pateExcelExport
		path = basePath + "pateExcelExport\\";
		file = new File(path);
		if (file.exists() && file.isDirectory()) {
			String[] filelist = file.list();
			for (int i = 0; i < filelist.length; i++) {
				File readfile = new File(path + "\\" + filelist[i]);
				if (!readfile.isDirectory()) {
					Date modify = new Date(readfile.lastModified());
					Long diff = now.getTime() - modify.getTime();
					if (diff / (1000 * 60) >= 20) {
						readfile.delete();
					}
				}
			}
		}

		// 删除明细下载生成的临时文件 detailExcelExport
		path = basePath + "detailExcelExport\\";
		file = new File(path);
		if (file.exists() && file.isDirectory()) {
			String[] filelist = file.list();
			for (int i = 0; i < filelist.length; i++) {
				File readfile = new File(path + "\\" + filelist[i]);
				if (!readfile.isDirectory()) {
					Date modify = new Date(readfile.lastModified());
					Long diff = now.getTime() - modify.getTime();
					if (diff / (1000 * 60) >= 20) {
						readfile.delete();
					}
				}
			}
		}

		// 删除切出来转PDF的excel文件 boxPates\Excels2Pdf
		path = basePath + "boxPates\\Excels2Pdf\\";
		file = new File(path);
		if (file.exists() && file.isDirectory()) {
			String[] filelist = file.list();
			for (int i = 0; i < filelist.length; i++) {
				File readfile = new File(path + "\\" + filelist[i]);
				if (!readfile.isDirectory()) {
					Date modify = new Date(readfile.lastModified());
					Long diff = now.getTime() - modify.getTime();
					if (diff / (1000 * 60) >= 20) {
						readfile.delete();
					}
				}
			}
		}

		// 删除用于打印的文件 boxPates\pdfFiles
		path = basePath + "boxPates\\pdfFiles\\";
		file = new File(path);
		if (file.exists() && file.isDirectory()) {
			String[] filelist = file.list();
			for (int i = 0; i < filelist.length; i++) {
				File readfile = new File(path + "\\" + filelist[i]);
				if (!readfile.isDirectory()) {
					Date modify = new Date(readfile.lastModified());
					Long diff = now.getTime() - modify.getTime();
					if (diff / (1000 * 60) >= 20) {
						readfile.delete();
					}
				}
			}
		}

		// 删除用于打印下载的文件 downfile
		path = this.getClass().getResource("/").toString()
				.replace("classes/", "downfile/").replace("file:/", "");
		file = new File(path);
		if (file.exists() && file.isDirectory()) {
			String[] filelist = file.list();
			for (int i = 0; i < filelist.length; i++) {
				File readfile = new File(path + "\\" + filelist[i]);
				if (!readfile.isDirectory()) {
					Date modify = new Date(readfile.lastModified());
					Long diff = now.getTime() - modify.getTime();
					if (diff / (1000 * 60) >= 20) {
						readfile.delete();
					}
				}
			}
		}

		// 删除导入箱规、装箱量的excel
		path = basePath + "uploadExcel\\";
		file = new File(path);
		if (file.exists() && file.isDirectory()) {
			String[] filelist = file.list();
			for (int i = 0; i < filelist.length; i++) {
				File readfile = new File(path + "\\" + filelist[i]);
				if (!readfile.isDirectory()) {
					Date modify = new Date(readfile.lastModified());
					Long diff = now.getTime() - modify.getTime();
					if (diff / (1000 * 60) >= 20) {
						readfile.delete();
					}
				}
			}
		}
		
		// 删除打印机生成的缓存文件
//		path ="C:\\ProgramData\\Seagull\\Drivers\\Dump\\";
//		file = new File(path);
//		if (file.exists() && file.isDirectory()) {
//			String[] filelist = file.list();
//			for (int i = 0; i < filelist.length; i++) {
//				File readfile = new File(path + "\\" + filelist[i]);
//				if (!readfile.isDirectory()) {
//					Date modify = new Date(readfile.lastModified());
//					Long diff = now.getTime() - modify.getTime();
//					if (diff / (1000 * 60) >= 20) {
//						readfile.delete();
//					}
//				}
//			}
//		}
		
		// 删除打印机生成的缓存文件
		path ="C:\\Windows\\System32\\spool\\PRINTERS\\";
		file = new File(path);
		if (file.exists() && file.isDirectory()) {
			String[] filelist = file.list();
			for (int i = 0; i < filelist.length; i++) {
				File readfile = new File(path + "\\" + filelist[i]);
				if (!readfile.isDirectory()) {
					Date modify = new Date(readfile.lastModified());
					Long diff = now.getTime() - modify.getTime();
					if (diff / (1000 * 60) >= 20) {
						try {
							readfile.delete();
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
		}

	}

	public static void main(String args[]) {
		FileUtil f = new FileUtil();
		f.delteFiles();
	}

	/**
	 * 获取WEB-INF路径
	 * @param c
	 * @param relativePath
	 * @return
	 */
	public static String getFileAbsolutePath(Class c, String relativePath) {
		String classPath = c.getClassLoader().getResource("/").getPath();
		classPath = classPath.replace("/", "\\");
		String filePath = classPath.substring(1, classPath.indexOf("classes\\")) + relativePath;
		return filePath;
	}
}
