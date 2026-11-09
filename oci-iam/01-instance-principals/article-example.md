# Using OCI Instance Principals without leaking credentials — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

The Java below runs only on an instance that belongs to the dynamic group. It reads from one bucket and has no credentials in code, environment variables or files. The namespace and bucket name come from configuration.

import com.oracle.bmc.auth.InstancePrincipalsAuthenticationDetailsProvider;

import com.oracle.bmc.objectstorage.ObjectStorageClient;

import com.oracle.bmc.objectstorage.requests.ListObjectsRequest;

public class ListConfigObjects {

public static void main(String[] args) throws Exception {

var provider = InstancePrincipalsAuthenticationDetailsProvider.builder().build();

try (var os = ObjectStorageClient.builder().build(provider)) {

var req = ListObjectsRequest.builder()

.namespaceName(System.getenv("OCI_NAMESPACE"))

.bucketName(System.getenv("CONFIG_BUCKET"))

.build();

os.listObjects(req).getListObjects().getObjects()

.forEach(o -> System.out.println(o.getName()));

}

}

}

The matching rule and policy for the dynamic group. The tag makes membership an explicit decision rather than a side effect of where an instance was created.

ALL {instance.compartment.id = '<apps_compartment_ocid>',

tag.department.runtime.value = 'payments'}

Allow dynamic-group app-runtimes to read objects in compartment apps

where target.bucket.name = 'app-config'

Allow dynamic-group app-runtimes to use log-content in compartment apps

If your dynamic group lives in a non-default identity domain, prefix the group name with the domain, for example dynamic-group MyDomain/app-runtimes.
