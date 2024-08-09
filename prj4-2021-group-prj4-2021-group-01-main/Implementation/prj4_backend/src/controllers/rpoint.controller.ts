import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getModelSchemaRef,
  patch,
  put,
  del,
  requestBody,
  response,
} from '@loopback/rest';
import {RPoint} from '../models';
import {RPointRepository} from '../repositories';

export class RpointController {
  constructor(
    @repository(RPointRepository)
    public rPointRepository : RPointRepository,
  ) {}

  @post('/r-points')
  @response(200, {
    description: 'RPoint model instance',
    content: {'application/json': {schema: getModelSchemaRef(RPoint)}},
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(RPoint, {
            title: 'NewRPoint',
            exclude: ['ID'],
          }),
        },
      },
    })
    rPoint: Omit<RPoint, 'ID'>,
  ): Promise<RPoint> {
    return this.rPointRepository.create(rPoint);
  }

  @get('/r-points/count')
  @response(200, {
    description: 'RPoint model count',
    content: {'application/json': {schema: CountSchema}},
  })
  async count(
    @param.where(RPoint) where?: Where<RPoint>,
  ): Promise<Count> {
    return this.rPointRepository.count(where);
  }

  @get('/r-points')
  @response(200, {
    description: 'Array of RPoint model instances',
    content: {
      'application/json': {
        schema: {
          type: 'array',
          items: getModelSchemaRef(RPoint, {includeRelations: true}),
        },
      },
    },
  })
  async find(
    @param.filter(RPoint) filter?: Filter<RPoint>,
  ): Promise<RPoint[]> {
    return this.rPointRepository.find(filter);
  }

  @patch('/r-points')
  @response(200, {
    description: 'RPoint PATCH success count',
    content: {'application/json': {schema: CountSchema}},
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(RPoint, {partial: true}),
        },
      },
    })
    rPoint: RPoint,
    @param.where(RPoint) where?: Where<RPoint>,
  ): Promise<Count> {
    return this.rPointRepository.updateAll(rPoint, where);
  }

  @get('/r-points/{id}')
  @response(200, {
    description: 'RPoint model instance',
    content: {
      'application/json': {
        schema: getModelSchemaRef(RPoint, {includeRelations: true}),
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(RPoint, {exclude: 'where'}) filter?: FilterExcludingWhere<RPoint>
  ): Promise<RPoint> {
    return this.rPointRepository.findById(id, filter);
  }

  @patch('/r-points/{id}')
  @response(204, {
    description: 'RPoint PATCH success',
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(RPoint, {partial: true}),
        },
      },
    })
    rPoint: RPoint,
  ): Promise<void> {
    await this.rPointRepository.updateById(id, rPoint);
  }

  @put('/r-points/{id}')
  @response(204, {
    description: 'RPoint PUT success',
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() rPoint: RPoint,
  ): Promise<void> {
    await this.rPointRepository.replaceById(id, rPoint);
  }

  @del('/r-points/{id}')
  @response(204, {
    description: 'RPoint DELETE success',
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.rPointRepository.deleteById(id);
  }
}
