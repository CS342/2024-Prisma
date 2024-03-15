<!--

This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project

SPDX-FileCopyrightText: 2023 Stanford University

SPDX-License-Identifier: MIT

-->

# CS342 2024 PRISMA

[![Build and Test](https://github.com/CS342/2024-Prisma/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/CS342/2024-Prisma/actions/workflows/build-and-test.yml)
[![codecov](https://codecov.io/gh/CS342/2024-Prisma/graph/badge.svg?token=Kl2PgPHuci)](https://codecov.io/gh/CS342/2024-Prisma)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10521597.svg)](https://doi.org/10.5281/zenodo.10521597)

This repository contains the CS342 2024 PRISMA application.
The CS342 2024 PRISMA application is using the [Spezi](https://github.com/StanfordSpezi/Spezi) ecosystem and builds on top of the [Stanford Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication).

> [!NOTE]  
> Do you want to try out the CS342 2024 PRISMA application? You can download it to your iOS device using [TestFlight](https://testflight.apple.com/join/bPu7kUoM)!
>
The CS342 2024 Prisma app as of March 14, 2023 includes added functionality for push notifications, controlling personal data usage via privacy controls, and authenticated chat interface dialogue. 


## CS342 2024 PRISMA Features
The following are screenshots showing various aspects of the Prisma application.

| Chat Interface | Notification Permissions | Data View |
|:------------------:|:------------------------:|:---------:|
| ![A Chat page.](Prisma/Supporting%20Files/PrismaApplication.docc/Resources/Onboarding/Chat.png#gh-light-mode-only) ![A Chat page.](Prisma/Supporting%20Files/PrismaApplication.docc/Resources/Onboarding/Chat~dark.png.png#gh-dark-mode-only) | ![A Notification Permissions page.](Prisma/Supporting%20Files/PrismaApplication.docc/Resources/Onboarding/NotificationPermissions.png#gh-light-mode-only) ![A Notification Permissions page.](Prisma/Supporting%20Files/PrismaApplication.docc/Resources/Onboarding/NotificationPermissions~dark.png#gh-dark-mode-only) | ![A data view.](Prisma/Supporting%20Files/PrismaApplication.docc/Resources/Onboarding/DataView.png#gh-light-mode-only) ![A data view.](Prisma/Supporting%20Files/PrismaApplication.docc/Resources/Onboarding/DataView~dark.png#gh-dark-mode-only) |


## Contributing

| Name       | Contribution |
|------------|--------------|
| **Caroline** | Implemented the UI, publisher, fetching, and modifying features for Firestore data given the user’s selection on data upload and redaction of data for the privacy controls. |
| **Dhruv**    | Wrote centralized privacy module class for management and storage of selected data. Worked collaboratively with Evelyn S. to create an end to end pipeline of chat interface authentication. |
| **Evelyn H.** | Implemented the UI for privacy controls, fetching and updating data in Firestore to reflect user changes in hiding data by timestamp or time range. |
| **Evelyn S.** | Worked collaboratively with Dhruv to create an end to end pipeline of chat interface authentication. The iOS app sends a JWT to the frontend, which then verifies the JWT using Firebase Admin SDK in the backend, and the user can then access the chat view
| **Bryant**   | Implemented client side handling for push notification registration + handling, as well as the backend listener system and scheduling for notifications/schedule changes. Also added testing framework to backend. |



## License

This project is licensed under the MIT License. See [Licenses](LICENSES) for more information.
