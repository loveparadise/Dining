

/**
 * Z_AFS_POMAILServiceTest.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.4.1  Built on : Aug 19, 2008 (10:13:39 LKT)
 */
    package mc_style.functions.soap.sap.document.sap_com;

    /*
     *  Z_AFS_POMAILServiceTest Junit test case
    */

    public class Z_AFS_POMAILServiceTest extends junit.framework.TestCase{

     
        /**
         * Auto generated test method
         */
        public  void testZAfsPomail() throws java.lang.Exception{

        mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub stub =
                    new mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub();//the default implementation should point to the right endpoint

           mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub.ZAfsPomail zAfsPomail4=
                                                        (mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub.ZAfsPomail)getTestObject(mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub.ZAfsPomail.class);
                    // TODO : Fill in the zAfsPomail4 here
                
                        assertNotNull(stub.ZAfsPomail(
                        zAfsPomail4));
                  



        }
        
         /**
         * Auto generated test method
         */
        public  void testStartZAfsPomail() throws java.lang.Exception{
            mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub stub = new mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub();
             mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub.ZAfsPomail zAfsPomail4=
                                                        (mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub.ZAfsPomail)getTestObject(mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub.ZAfsPomail.class);
                    // TODO : Fill in the zAfsPomail4 here
                

                stub.startZAfsPomail(
                         zAfsPomail4,
                    new tempCallbackN65548()
                );
              


        }

        private class tempCallbackN65548  extends mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceCallbackHandler{
            public tempCallbackN65548(){ super(null);}

            public void receiveResultZAfsPomail(
                         mc_style.functions.soap.sap.document.sap_com.Z_AFS_POMAILServiceStub.ZAfsPomailResponse result
                            ) {
                
            }

            public void receiveErrorZAfsPomail(java.lang.Exception e) {
                fail();
            }

        }
      
        //Create an ADBBean and provide it as the test object
        public org.apache.axis2.databinding.ADBBean getTestObject(java.lang.Class type) throws java.lang.Exception{
           return (org.apache.axis2.databinding.ADBBean) type.newInstance();
        }

        
        

    }
    