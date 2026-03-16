#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

# Set by GH actions, see
# https://docs.github.com/en/actions/learn-github-actions/environment-variables#default-environment-variables
TAG=${GITHUB_REF_NAME}
ARCHIVE="googleapis-rules-registry-${TAG}.tar.gz"
# Archive without a top-level prefix so that the per-module strip_prefix in
# .bcr/<module>/source.template.json (e.g. "googleapis-cc") works correctly.
git archive --format=tar ${TAG} | gzip > ${ARCHIVE}
SHA=$(shasum -a 256 $ARCHIVE | awk '{print $1}')

cat << EOF
## Usage

Add the desired modules to your \`MODULE.bazel\` file:

\`\`\`starlark
# Choose the language modules you need:
bazel_dep(name = "googleapis-cc", version = "${TAG:1}")
bazel_dep(name = "googleapis-go", version = "${TAG:1}")
bazel_dep(name = "googleapis-java", version = "${TAG:1}")
bazel_dep(name = "googleapis-python", version = "${TAG:1}")
bazel_dep(name = "googleapis-grpc-cc", version = "${TAG:1}")
bazel_dep(name = "googleapis-grpc-java", version = "${TAG:1}")
bazel_dep(name = "googleapis-upb", version = "${TAG:1}")
\`\`\`
EOF
