# How Code Becomes a Trusted Release: The KijaniKiosk Payments Pipeline

Every time one of our engineers finishes a piece of work on the payments
service, it doesn't go live automatically. Instead, it passes through an
automated review process that checks the work before it's allowed to become
an official, trackable version of the product. This process runs the same
way, every time, without a person needing to remember each step. That
consistency is what lets us move quickly without taking on unnecessary risk
in a financial services product.

## What happens between a push and a published release

When an engineer saves their change to our shared codebase, the process
starts immediately, with no manual trigger required. It works through five
checks, each one building on the last:

| Step | What it confirms |
|---|---|
| Style Check | The code follows the team's agreed formatting and structure rules |
| Build | The code actually compiles into a working application |
| Testing | The application behaves the way it's supposed to |
| Security Check | No known vulnerable components have been introduced |
| Packaging | A verified, labeled copy of the release is created |
| Publishing | That verified copy is stored in our official registry, permanently linked to the exact change that produced it |

Testing and the security check happen at the same time, since they check
different things and don't depend on each other. This cuts the total time
the whole process takes without cutting any corners.

Every release that reaches the registry is labeled with a unique version
number tied directly to the change that created it. That means if a question
ever comes up about what's running in production, we can trace it back to
the exact piece of work responsible — which matters enormously for a
platform handling financial transactions and audit requirements.

## What Happens When Something Goes Wrong

If any single check fails, everything after it stops immediately. A change
that doesn't meet our formatting rules never gets built. A change that
doesn't build never gets tested. A change that fails testing or the security
check never gets packaged or published. Nothing broken is ever allowed to
reach the official registry.

When a check fails, the engineer responsible is told right away, with the
specific reason their change was stopped. This means problems are caught and
fixed within minutes of being introduced, rather than being discovered later
when they're harder — and more expensive — to trace back to their source.

## What this doesn't yet do

Today, this process stops once a verified release is stored in our
registry. It does not yet automatically deploy that release into production,
and there is no automated way to roll back a release once it's live. Moving
a release into production, and handling what happens if something needs to
be undone, is the next phase of work our team is building toward.