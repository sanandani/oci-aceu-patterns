# OCIR basics: push/pull, private repos, auth tokens — worked example

Verbatim worked-example text from the matching enhanced article draft. Commands and code are retained in source order; angle-bracket values are placeholders.

Log in with the registry endpoint for your region. The username begins with your tenancy namespace. If your user belongs to a non-default identity domain or is federated, the username format changes, so check the documentation for your case.

docker login <region-key>.ocir.io

# Username: <tenancy-namespace>/<username>

# Password: <auth-token>

oci artifacts container repository create \

--compartment-id <compartment_ocid> \

--display-name myteam/myapp \

--is-public false

docker tag myapp:1.4.2 <region-key>.ocir.io/<tenancy-namespace>/myteam/myapp:1.4.2

docker push <region-key>.ocir.io/<tenancy-namespace>/myteam/myapp:1.4.2

And the policies, kept separate for people who browse and people who manage:

Allow group image-viewers to inspect repos in tenancy

Allow group image-publishers to manage repos in compartment registry

I tag with a version, not latest, so a rollback is a one-line change. A user can hold only a small number of auth tokens, so plan token replacement for your pipelines before it is urgent.
