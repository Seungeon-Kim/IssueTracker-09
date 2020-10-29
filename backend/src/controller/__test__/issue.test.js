/* eslint-disable no-undef */
const issueController = require('../issue');
const issueService = require('../../service/issue');

const httpMocks = require('node-mocks-http');

issueService.read = jest.fn();

const newIssue = [
  {
    id: 1,
    title: 'title',
    content: 'content',
    is_opended: true,
    timestamp: '2020-20-20',
    milestone_id: 1,
    user_id: 1,
    Milestone: {
      title: 'title',
      content: 'content',
      deadline: '2020-20-20',
      is_opened: true,
    },
    AssigneeIssue: [
      {
        user_id: 1,
      },
    ],
    LabelIssue: [
      {
        label_id: 1,
      },
    ],
    Comment: {
      commentCount: 1,
    },
  },
];

beforeEach(() => {
  req = httpMocks.createRequest();
  res = httpMocks.createResponse();
});

describe('read issue Controller 테스트', () => {
  it('함수인가', () => {
    expect(typeof issueController.read).toBe('function');
  });

  it('성공 시 200응답이 오는가', async () => {
    issueService.read.mockReturnValue(newIssue);
    await issueController.read(req, res);
    expect(res.statusCode).toBe(200);
    expect(res._isEndCalled()).toBeTruthy();
  });

  it('json을 리턴하는가', async () => {
    issueService.read.mockReturnValue(newIssue);
    await issueController.read(req, res);
    expect(res._isJSON()).toBeTruthy();
  });

  it('에러가 나면 403응답이 오는가', async () => {
    const errorMessage = { error: 'Error Message' };
    issueService.read.mockReturnValue(errorMessage);
    await issueController.read(req, res);
    expect(res.statusCode).toBe(403);
    expect(res._isEndCalled()).toBeTruthy();
  });

  it('서버에서 에러가 나면 500응답이 오는가', async () => {
    const errorMessage = { error: 'Error Message' };
    const rejectedPromise = Promise.reject(errorMessage);
    issueService.read.mockReturnValue(rejectedPromise);
    await issueController.read(req, res);
    expect(res.statusCode).toBe(500);
  });
});
