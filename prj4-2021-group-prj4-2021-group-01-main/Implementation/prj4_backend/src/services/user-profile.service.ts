import {UserService} from '@loopback/authentication';
import {repository} from '@loopback/repository';
import {HttpErrors} from '@loopback/rest';
import {securityId, UserProfile as UserProfileLoopback} from '@loopback/security';
import {compare} from 'bcryptjs';
import {UserProfile, UserProfileWithRelations} from '../models';
import {UserProfileRepository} from '../repositories';
import {BindingKey} from "@loopback/core";

/**
 * A pre-defined type for user credentials. It assumes a user logs in
 * using the email and password. You can modify it if your app has different credential fields
 */
export type Credentials = {
    email: string;
    password: string;
};

export class UserProfileService implements UserService<UserProfile, Credentials> {
    constructor(
        @repository(UserProfileRepository) public userRepository: UserProfileRepository,
    ) {}

    async verifyCredentials(credentials: Credentials): Promise<UserProfile> {
        const invalidCredentialsError = 'Invalid email or password.';

        const foundUser = await this.userRepository.findOne({
            where: {EMAIL: credentials.email},
        });
        if (!foundUser) {
            throw new HttpErrors.Unauthorized(invalidCredentialsError);
        }



        const passwordMatched = await compare(
            credentials.password,
            foundUser.PASS,
        );

        if (!passwordMatched) {
            throw new HttpErrors.Unauthorized(invalidCredentialsError);
        }

        return foundUser;
    }

    // @ts-ignore
    convertToUserProfile(user: UserProfile): UserProfileLoopback {
        return {
            [securityId]: user.ID!.toString(),
            name: user.USR_NAME,
            id: user.ID,
            email: user.EMAIL,
        };
    }

    //function to find user by id
    async findUserById(id: string): Promise<UserProfile & UserProfileWithRelations> {
        const userNotfound = 'invalid User';
        const foundUser = await this.userRepository.findOne({
            // where: {id: id},
        });

        if (!foundUser) {
            throw new HttpErrors.Unauthorized(userNotfound);
        }
        return foundUser;
    }


}
export namespace UserProfileServiceBindings {
    export const USER_PROFILE_SERVICE = BindingKey.create<UserService<UserProfile, Credentials>>(
        'services.user.service',
    );
}
