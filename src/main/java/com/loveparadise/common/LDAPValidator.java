package com.loveparadise.common;

import java.util.Hashtable;

import javax.naming.AuthenticationException;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.Control;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;

import com.loveparadise.model.User;

public class LDAPValidator {
	private String URL = "ldap://192.168.64.1:389/";
	private String BASEDN = "DC=ANTA,DC=COM";
	private String FACTORY = "com.sun.jndi.ldap.LdapCtxFactory";
	private LdapContext ctx = null;
	private Hashtable env = null;
	private Control[] connCtls = null;

	private String userName;

	private String password;

	private User loginUser;

	private void LDAP_connect() {
		env = new Hashtable();
		env.put(Context.INITIAL_CONTEXT_FACTORY, FACTORY);
		env.put(Context.PROVIDER_URL, URL + BASEDN);// LDAP server
		env.put(Context.SECURITY_AUTHENTICATION, "simple");
		env.put(Context.SECURITY_PRINCIPAL, userName + "@" + "ANTA.COM");
		env.put(Context.SECURITY_CREDENTIALS, password);

		try {
			ctx = new InitialLdapContext(env, connCtls);
		} catch (javax.naming.AuthenticationException e) {
			System.out.println("Authentication faild: " + e.toString());
		} catch (Exception e) {
			System.out.println("Something wrong while authenticating: "
					+ e.toString());
		}
	}

	private String getUserDN(String userName) {
		String userDN = "";

		LDAP_connect();

		try {
			SearchControls constraints = new SearchControls();
			constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);
			NamingEnumeration en = ctx.search("", "sAMAccountName=" + userName,
					constraints);
			if (en == null) {
				System.out.println("Have no NamingEnumeration.");
			}
			if (!en.hasMoreElements()) {
				System.out.println("Have no element.");
			}
			while (en != null && en.hasMoreElements()) {
				Object obj = en.nextElement();
				if (obj instanceof SearchResult) {
					SearchResult si = (SearchResult) obj;

					Attributes Attrs = si.getAttributes();
					if (Attrs != null) {
						try {
							for (NamingEnumeration ne = Attrs.getAll(); ne
									.hasMore();) {
								Attribute Attr = (Attribute) ne.next();
								// System.out.println(" AttributeID="
								// + Attr.getID().toString());

								String elementName = "";

								if (Attr.getID().toString()
										.equalsIgnoreCase("displayName"))
									elementName = "displayName";
								else if (Attr.getID().toString()
										.equalsIgnoreCase("department"))
									elementName = "department";
								else if (Attr.getID().toString()
										.equalsIgnoreCase("title"))
									elementName = "title";
								else if (Attr.getID().toString()
										.equalsIgnoreCase("description"))
									elementName = "description";
								else
									elementName = "";
								for (NamingEnumeration e = Attr.getAll(); e
										.hasMore();) {
									String element = e.next().toString();

									if (elementName
											.equalsIgnoreCase("displayName")) {
										loginUser.setName(element);
									}
								}

							}
						} catch (NamingException e) {
							System.err.println("Throw Exception : " + e);
						}
					}

					userDN += si.getName();
					userDN += "," + BASEDN;
				} else {
					System.out.println(obj);
				}
			}
		} catch (Exception e) {
			System.out.println("Exception in search():" + e);
		}

		return userDN;
	}

	public boolean authenricate(String userName, String password) {
		this.userName = userName;
		this.password = password;
		loginUser = new User();
		boolean valide = false;
		String userDN = getUserDN(userName);

		// if (userDN != null && userDN.length() > 0) {
		// int begin = userDN.indexOf(",CN=");
		// int end = userDN.indexOf(",DC=");
		// if (begin > 0 && end > 0 && (begin + 4) < end)
		// loginUser.setCenter(userDN.substring(begin + 4, end));
		// }

		try {
			ctx.addToEnvironment(Context.SECURITY_PRINCIPAL, userDN);
			ctx.addToEnvironment(Context.SECURITY_CREDENTIALS, password);
			ctx.reconnect(connCtls);
			System.out.println(userDN + " is authenticated");
			valide = true;
		} catch (AuthenticationException e) {
			System.out.println(userDN + " is not authenticated");
			System.out.println(e.toString());
			valide = false;
		} catch (NamingException e) {
			System.out.println(userDN + " is not authenticated");
			valide = false;
		} catch (Exception e) {
			System.out.println(userDN + " is not authenticated");
			valide = false;
		}

		return valide;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public User getLoginUser() {
		return loginUser;
	}
}