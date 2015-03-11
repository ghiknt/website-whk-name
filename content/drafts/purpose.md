---
title: Why I am creating whk.name and erpetu.info
summary: >
 whk.name and erpetu.info will hopefully provide a platform for development of small team open business models and
 of a free, distributed, decentralized compute infrastructure.
type: blog
license: ccbysa
author:
 - { name: "whk", url: "https://whk.name/about/me/#id" }
created: 9999-01-01
modified: 9999-01-01
reviewed: 9999-01-01

---

Concerns
========================================================================================================
I have read in multiple places that in order to have a successful project one needs to feel
strongly about what he is trying to achieve.  While there are multiple reasons that I am creating this and
upcoming project sites, there are a couple of overarching concerns that are driving the direction of my development.

* The bleak prospects for the long term health of free software in the current trend of SaaS, PaaS, and IaaS implementations

    The current trend of using free and opensource software to kickstart projects and services
    and then adding a proprietary layer of code on top distrubs me. In addition, even if the entire software stack
    is opensource, by locking users data behind cloud services the end user may be using opensource but he has
    no freedom in his use of the system.  I would like to see a cloud system which is defined by a shared pooling of
    resources for common interests where the user has full control.

* Lottery winner vs Journeyman mentality

    Rather than fostering an environment where people can spend thier lives working on interesting
    projects that provide long term benefits, the current culture stresses the ability to create a 
    hit viral product that can be quickly monitized with the hope of hitting it rich.   I believe that
    a business model that provides a life time of income in exchange for a life time of profitable work
    to be a better long term model.

Hopes
========================================================================================================
Ultimately I would like to have a couple of sites that together work towards my preference for a better  "cloud" environment
and that explore sustainable business models for development.

* <https://whk.name/>:

    * Acts as my permanant online identity

    * Provide a set of reference documents that independent and small team developers can
      use to found thier own sites and projects.

    * Provide resources to encourage decentralized and distributed free software
      projects that push the bounds of an open web.

    * Act as the entry point to my personal resources that participate in the erpetu cloud.
        
* <https://erpetu.info>:

    * Provide components and an entry point for a free, distributed, decentralized shared compute infrastructure.
      That has the following properties:

        * Free

            * Built from the ground up on Free (as in Freedom)[@FreeSoftwareFoundation2015] software and
              business practices

            * Foster a bazaar development model[@Raymond2002]

                * The only CLA if there is one would be a digitally signed statement that the user has
                  the legal write to contribute a work under the given license.

            * A user 
            
                * determines who can access his data
                
                * determines on what systems his data can be processed

                * what programs he trusts to run

            * A system owner 
            
                * determines who can use the system
                
                * determines what software can run on the system

                * determines what data can run on the system

            * Heterogeneous not homogeneous:  While erpetu.info should provide an entry point into the cloud, the design
              should encourage others to create their own clouds and entry points which then can then combine (if desired)
              into a larger cloud.

               

        * Decentralized

            * Authentication needs to be based on a decentralized model that should

                * Require no third party to create a new identity

                * Allow for unique identification

                * Allow true or pseudonymous personal and organizational identities

                * Identity is defined by the collective agreement of others (ala Web of Trust) rather than a centralized authority.

            * Software sources are digitally signed

            * Software and services are digitally signed

            * Systems and virtual containers have an identity


        * Distributed

             * Authorization

                 * The amount and type of trust given to a user, software program or service is based on both the user and
                   the system being used.

             * The erpetu cloud should appear to be a microkernel based distributed operating system.
               It should have layered on it several shared services:

                 * A blockchain (or similar) ledger to record consensus information

                 * A P2P Encrypted Object store 

                 * Virtual containers that distributes a programs processing across multiple real and virtual containers.

                 * A authorization service that allows the trust of a user, software program, service, or data store to
                   be based on the aggregate of the operator, the virtual container, and the physical system it is being
                   accessed on.



Dreams
========================================================================================================

Those who know me know that I enjoy the journey of figuring out how to do something. But I have issues
at times staying the course once I know where I am going.  Because of this trait I intend to
hack my workflow processes so that as I continue to expore new ideas they will be turned naturally into products
people can use.   While I expect that these processes will change dramatically over time below is my first 
draft for the readers amusement.

* <https://whk.name/about/>:

    * First document the specific configurations used to develop and run my projects.  

    * Then to extract the information in those configurations into a cookbook style web book
      that would allow a developer to find information relevant to his tasks.

    * And finally provide blog posts like this one that explains the context of why I decided
      to do things in a certain way.

    * Explore and document various business models that an individual or small team can use.

* <https://erpetu.info/>:
    
    * Guiding principles

    * Develop low level components, applications, and infrastructure.

      Starting with low level components and then work up to a few system.  Each piece should be usable as is.

    * Application development

        * Develop a set of Web Components[@WebComponents.orgcontributors] that can can be used on the desktop, web browser,
          mobile platforms.
          The basic design of each component will be

            * HTML/CSS/Javascript for the user interface layer

            * C code compiled to asm.js for any heavy lifting

        * Develop a set of user applications

    * Infrastructure development

        * Authentication systems:  
           More research is needed to determine
           what I like the best but the following gives a feel of what I am looking for

            * GPG

            * [https://www.w3.org/wiki/WebID](WebID)


References
===========================================================================================================

