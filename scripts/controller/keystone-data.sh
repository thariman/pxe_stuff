#!/bin/sh
#
# Keystone Datas
#
# Description: Fill Keystone with datas.

# Mainly inspired by http://www.hastexo.com/resources/docs/installing-openstack-essex-20121-ubuntu-1204-precise-pangolin
# Written by Martin Gerhard Loschwitz / Hastexo
# Modified by Emilien Macchi / StackOps
#
# Support: openstack@lists.launchpad.net
# License: Apache Software License (ASL) 2.0
#

ADMIN_PASSWORD=${ADMIN_PASSWORD:-password}
SERVICE_PASSWORD=${SERVICE_PASSWORD:-$ADMIN_PASSWORD}
export SERVICE_TOKEN="password"
export SERVICE_ENDPOINT="http://localhost:35357/v2.0"
SERVICE_TENANT_NAME=${SERVICE_TENANT_NAME:-service}

get_id () {
    echo `$@ | awk '/ id / { print $4 }'`
}

# Tenants
ADMIN_TENANT=$(get_id keystone tenant-create --name=admin)
SERVICE_TENANT=$(get_id keystone tenant-create --name=$SERVICE_TENANT_NAME)
DEMO_TENANT=$(get_id keystone tenant-create --name=demo)
INVIS_TENANT=$(get_id keystone tenant-create --name=invisible_to_admin)

# Users
ADMIN_USER=$(get_id keystone user-create --name=admin --pass="$ADMIN_PASSWORD" --email=admin@domain.com)
DEMO_USER=$(get_id keystone user-create --name=demo --pass="$ADMIN_PASSWORD" --email=demo@domain.com)

# Roles
ADMIN_ROLE=$(get_id keystone role-create --name=admin)
KEYSTONEADMIN_ROLE=$(get_id keystone role-create --name=KeystoneAdmin)
KEYSTONESERVICE_ROLE=$(get_id keystone role-create --name=KeystoneServiceAdmin)

# Add Roles to Users in Tenants
keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $ADMIN_TENANT
keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $DEMO_TENANT
keystone user-role-add --user-id $ADMIN_USER --role-id $KEYSTONEADMIN_ROLE --tenant-id $ADMIN_TENANT
keystone user-role-add --user-id $ADMIN_USER --role-id $KEYSTONESERVICE_ROLE --tenant-id $ADMIN_TENANT

# The Member role is used by Horizon and Swift
MEMBER_ROLE=$(get_id keystone role-create --name=Member)
keystone user-role-add --user-id $DEMO_USER --role-id $MEMBER_ROLE --tenant-id $DEMO_TENANT
keystone user-role-add --user-id $DEMO_USER --role-id $MEMBER_ROLE --tenant-id $INVIS_TENANT

# Configure service users/roles
NOVA_USER=$(get_id keystone user-create --name=nova --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=nova@domain.com)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $NOVA_USER --role-id $ADMIN_ROLE

GLANCE_USER=$(get_id keystone user-create --name=glance --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=glance@domain.com)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $GLANCE_USER --role-id $ADMIN_ROLE

SWIFT_USER=$(get_id keystone user-create --name=swift --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=swift@domain.com)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $SWIFT_USER --role-id $ADMIN_ROLE

RESELLER_ROLE=$(get_id keystone role-create --name=ResellerAdmin)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $NOVA_USER --role-id $RESELLER_ROLE

QUANTUM_USER=$(get_id keystone user-create --name=quantum --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=quantum@domain.com)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $QUANTUM_USER --role-id $ADMIN_ROLE

CINDER_USER=$(get_id keystone user-create --name=cinder --pass="$SERVICE_PASSWORD" --tenant-id $SERVICE_TENANT --email=cinder@domain.com)
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $CINDER_USER --role-id $ADMIN_ROLE
