import java.io.IOException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.PrintStream;

import org.apache.tika.parser.pdf.PDFParser;
import org.apache.tika.metadata.Metadata;
import org.apache.tika.parser.ParseContext;
import org.apache.tika.sax.BodyContentHandler;
import org.xml.sax.ContentHandler;

 
public class ConverterApp {

   private static void convert(String fname, PrintStream out) throws Exception {
      // Convert pdf file "fname" to text.
      FileInputStream is = null;
      try {
         is = new FileInputStream(fname);
         ContentHandler contenthandler = new BodyContentHandler(-1);
         Metadata metadata = new Metadata();
         PDFParser pdfparser = new PDFParser();
         pdfparser.parse(is, contenthandler, metadata, new ParseContext());
         out.println(contenthandler.toString());
      }
      catch (Exception e) {
         e.printStackTrace();
      }
      finally {
         if (is != null) is.close();
      }
   }

   private static boolean not_a_pdf_name (String fname) {
      int dot = fname.lastIndexOf('.');
      return !fname.substring(dot+1).equalsIgnoreCase("pdf");
   }

   private static PrintStream outputf(String infname) {
      String outfname = infname.replaceFirst("pdf$", "txt");
      PrintStream stream = null;
      try {
         stream = new PrintStream(new FileOutputStream(outfname, true));
      }
      catch (IOException e) {
         e.printStackTrace();
      }
      return stream;
   }

   public static void main(String args[]) throws Exception {
      boolean tostdout = false;
      if (args.length < 1) {
         // No argument.
         System.exit(0);
      }
      int i = 0;
      for ( ; i < args.length && args[i].charAt(0) == '-' ; i++) {
         if (args[i].equals("--to-stdout")) tostdout = true;
      }
      // Convert input files.
      for ( ; i < args.length ; i++) {
         if (not_a_pdf_name(args[i])) continue;
         if (tostdout) {
            convert(args[i], System.out);
         }
         else {
            PrintStream stream = null;
            try {
               stream = outputf(args[i]);
               convert(args[i], stream);
            }
            finally {
               if (stream != null) stream.close();
            }
         }
      }
   }
}
