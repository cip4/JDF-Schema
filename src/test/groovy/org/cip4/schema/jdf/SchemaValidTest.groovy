package org.cip4.schema.jdf

import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.MethodSource

import javax.xml.XMLConstants
import javax.xml.transform.stream.StreamSource
import javax.xml.validation.SchemaFactory

class SchemaValidTest {

    @ParameterizedTest
    @MethodSource('schemas')
    void schemaFileIsValidXml(File schema) {
        def xsdUrl = new URL("https://www.w3.org/2001/XMLSchema.xsd")

        xsdUrl.withInputStream { xsd ->
            schema.withInputStream { xml ->
                SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI)
                        .newSchema(new StreamSource(xsd, xsdUrl.toString()))
                        .newValidator()
                        .validate(new StreamSource(xml, schema.name))
            }
        }
    }

    @Test
    void schemaFilesAreLocated() {
        Assertions.assertTrue(schemas().size() == 8)
    }

    static Collection<File> schemas() {
        return new File('.').listFiles(new FilenameFilter() {
            @Override
            boolean accept(File dir, String name) {
                return name.endsWith('.xsd')
            }
        })
    }
}