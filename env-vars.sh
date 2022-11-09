# Required for the OCI Provider
export TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaaubrkzed3mzqxtsxx4qnfgmcmoh5mm7r6r33e3joefrayjnrmf7oa"
#export TF_VAR_compartment_ocid="ocid1.compartment.oc1..aaaaaaaavhzfipnyxtunwknfzrcfqybooesjdoctb2vjycmrepya264p2poq"
export TF_VAR_compartment_ocid="ocid1.compartment.oc1..aaaaaaaafqqzlp3q7hinidlksbhanwlw7trv74sv6tkbympy72a5kmyui6eq"
export TF_VAR_user_ocid="ocid1.user.oc1..aaaaaaaaqxbkfx3urtvnu7phbo7vt2qbn7paclireneja2hse7f6dokt365a"
export TF_VAR_fingerprint=$(cat ~/.oci/oci_api_key.fingerprint)
export TF_VAR_private_key_path="~/.oci/oci_api_key.pem"
export TF_VAR_region="us-phoenix-1"

# Keys used to SSH to OCI VMs
export TF_VAR_ssh_public_key=$(cat ~/.ssh/oci.pub)
export TF_VAR_ssh_private_key=$(cat ~/.ssh/oci.pem)
