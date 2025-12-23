# Contributing

Flux Operator is [AGPL-3.0 licensed](https://github.com/controlplaneio-fluxcd/flux-operator/blob/main/LICENSE)
and accepts contributions via GitHub pull requests. This document outlines
some of the conventions on how to make it easier to get your contribution accepted.

## Certificate of Origin

By contributing to this project, you agree to the Developer Certificate of
Origin ([DCO](https://developercertificate.org/)). This document was created by the Linux Kernel community and is a
simple statement that you, as a contributor, have the legal right to make the contribution.

> You must sign-off your commits with your name and email address using `git commit -s`.

## Perquisites

Please ensure you have the following tools installed:

- [helm](https://helm.sh/docs/intro/install/)
- [helm-docs](https://github.com/norwoodj/helm-docs)
- [helm-values-schema-json](https://github.com/losisin/helm-values-schema-json)

## Acceptance policy

Before opening a PR, run `make manifests` to update the values JSON schema and README file.

Please test your changes on a Kubernetes cluster by installing
the Helm chart built from your fork:

```shell
helm upgrade --install flux-operator .charts/flux-operator \
  --namespace flux-system \
  --create-namespace \
  --wait
```

In general, we will merge a PR once one maintainer has endorsed it.
For significant changes, more people may become involved, and you might
get asked to resubmit the PR or divide the changes into more than one PR.

### Format of the Commit Message

For this project, we prefer the following rules for good commit messages:

- Limit the subject to 50 characters and write as the continuation
  of the sentence "If applied, this commit will ..."
- Explain what and why in the body, if more than a trivial change;
  wrap it at 72 characters.

The [following article](https://chris.beams.io/posts/git-commit/#seven-rules)
has some more helpful advice on documenting your work.
