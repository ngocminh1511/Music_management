package model.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.Instant;

import javax.servlet.ServletContext;
import javax.servlet.http.Part;

public class FileUploadUtil {
    public static String save(Part part, String webSubDir, ServletContext ctx) throws IOException {
        if (part == null || part.getSize() == 0) {
			return null;
		}
        String fileName = sanitize(extractFileName(part));
        String ext = "";
        int dot = fileName.lastIndexOf('.');
        if (dot >= 0) {
			ext = fileName.substring(dot);
		}
        String newName = Instant.now().toEpochMilli() + ext;

        String webPath = "/assets/" + webSubDir + "/" + newName; // e.g., music or thumbs or avatars
        String abs = ctx.getRealPath(webPath);
        if (abs == null) {
			throw new IOException("Cannot resolve real path for " + webPath);
		}

        File dir = new File(abs).getParentFile();
        if (!dir.exists() && !dir.mkdirs()) {
			throw new IOException("Cannot create directory: " + dir);
		}

        Path target = new File(abs).toPath();
        try {
            Files.copy(part.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
        } finally {
            part.delete();
        }
        return webPath;
    }

    private static String extractFileName(Part part) {
        String cd = part.getHeader("content-disposition");
        if (cd == null) {
			return "upload.bin";
		}
        for (String c : cd.split(";")) {
            c = c.trim();
            if (c.startsWith("filename")) {
                String name = c.substring(c.indexOf('=') + 1).trim().replace("\"", "");
                return new File(name).getName();
            }
        }
        return "upload.bin";
    }

    private static String sanitize(String name) {
        return name.replaceAll("[^a-zA-Z0-9._-]", "_");
    }
}