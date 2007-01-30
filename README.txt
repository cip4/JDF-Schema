README 2006-07-13
		
This Ant script (build.xml) runs tests on the JDF XML Schema. First the correctness of the 
JDF Schema is verified, then the JDF Schema is used to validate a number of JDF/JMF files.

If the JDF Schema passes all tests the build will complete successfully. If a test does 
not pass the build will immediately abort and fail. Look at the output in the console 
to determine why the test failed.

Run 'ant' to run all tests.
Run 'ant -p' for a description of available targets if you want to run a specific test.

The validation tools, used by this script can be downloaded from 
http://elk.itn.liu.se/schema/validators.zip. If needed the paths to files and validators 
can be customized in 'build.properties'.
	
Dependencies:
1. Apache Ant 1.6 -- http://ant.apache.org
2. CIP4 JDF Schema -- http://www.cip4.org/documents/jdf_specifications/index.html#schema
3. XSV -- ftp://ftp.cogsci.ed.ac.uk/pub/XSV/
4. ant-contrib -- http://ant-contrib.sourceforge.net
5. XPath Evaluator Task -- http://www.jtech.se/xpath-test/
6. Xerces J -- http://xerces.apache.org/xerces2-j/
7. MSXML.NET
8. IBM XML Schema Qualiy Checker (optional) -- http://www.alphaworks.ibm.com/tech/xmlsqc

Dependencies 3-8 are included in the validation tools ZIP archive referenced above.
For more information contact the CIP4 Tools & Infrastructure working group.